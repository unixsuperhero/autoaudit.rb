
### tl;dr ###
Rough diff of the AutoAudit module/mixin/dsl.

### WHO: ###
Joshua "Unix Superhero" Toyota

### DESCRIPTION: ###
Sometimes you want to keep track of any changes to a database table.
This lets you keep track of:
* Any changes to a db record
* What record was changed
* When it was changed
* What it changed from
* What it changed to
To say it in plain English:
> User model, anytime (any column changes || columns x, y, or z change) save
> the Before/After values with the time they changed.

> (If we are lucky, we can find out who changed them, and a description of why
> they were changed (disposition in call center terms).  However, I find it
> hard to generalize these last 2 parts.)

### WHEN: ###
2012-12-09
> (I thought I did this much sooner than the given date.  Dante was still at
> saveology then.)

### WHERE: ###
Saveology, LLC

### WHY: ###
We needed to keep track of Historical Data at work.  Everyone else was
over-engineering it and coupling it with our implementation; which creates
dependencies.  From the beginning I explained that there was a simple,
reusable, and easy to abstract solution.

### HOW: ###
* Include the AutoAudit module.  (Will be a gem in the future.)
* Then add 1 line of code to each model you want to track:
 * Either:
   audit columns: ['x','y','z']
 * Or:
   audit columns: %w{x y z}
 * Or:
   audit_all

* In the background this will:
 * Add a before_save callback
 * Add the has_many association to the changes model.

### SETUP: ###
- You need to create the audit models/tables first though.
 - (UserChange for the User model.  OrderChange for the Order model.)


### OTHER STUFF: ###
#### Future enhancements may include: ####
Changes table is a polymorphic association, if it isn't already.  This way you
don't have to create a UserChange model.  You just make a Change model with:

    create_table :changes do |t|
      t.string :table_type
      t.integer :table_id
      t.text :before
      t.text :after
    
      t.timestamps
    end

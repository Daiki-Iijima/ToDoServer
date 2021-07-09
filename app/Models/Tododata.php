<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tododata extends Model
{
    use HasFactory;

    protected $table = 'todo';
    protected $guarded = array('id');
}

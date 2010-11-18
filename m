Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab0KRTfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 14:35:22 -0500
Received: from mail.wdtv.com ([66.118.69.84]:53227 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab0KRTfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 14:35:20 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Thomas Backlund <tmb@mandriva.org>
Subject: Re: Galbraith patch
Date: Thu, 18 Nov 2010 14:35:17 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
References: <1290018947.4887.14.camel@note-311a> <1290096365.30211.5.camel@maggy.simson.net> <4CE5731B.20807@mandriva.org>
In-Reply-To: <4CE5731B.20807@mandriva.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011181435.17062.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 18, 2010, Thomas Backlund wrote:
>Mike Galbraith skrev 18.11.2010 18:06:
>> On Thu, 2010-11-18 at 13:43 -0200, Gilberto Nunes wrote:
>>> Hi...
>>> 
>>> Someone can help with this????
>> 
>> Hey, patience please, I'm on vacation :)
>> 
>> You can try the below if you like.  It's what I'm currently tinkering
>> with, and has a patch it depends on appended for ease of application.
>> Should apply cleanly to virgin 2.6.36.
>
>[...]
>
>This diffstat does not match the patch:
>---
>
>>   Documentation/kernel-parameters.txt |    2
>>   include/linux/sched.h               |   19 ++++
>>   init/Kconfig                        |   12 ++
>>   kernel/fork.c                       |    5 -
>>   kernel/sched.c                      |   13 ++
>>   kernel/sched_autogroup.c            |  170
>>   ++++++++++++++++++++++++++++++++++++ kernel/sched_autogroup.h       
>>       |   23 ++++
>>   kernel/sched_debug.c                |   29 +++---
>>   kernel/sys.c                        |    4
>>   kernel/sysctl.c                     |   11 ++
>
>It's really:
>>  Documentation/kernel-parameters.txt |    2 ++
>>  include/linux/sched.h               |   21 ++++++++++++++++++++-
>>  init/Kconfig                        |   12 ++++++++++++
>>  kernel/fork.c                       |    5 ++++-
>>  kernel/sched.c                      |   21 +++++++++++++++------
>>  kernel/sched_debug.c                |   29
>>  +++++++++++++++-------------- kernel/sched_fair.c                 |  
>>  25 +++++++++++++++++++------ kernel/sys.c                        |   
>>  4 +++-
>>  kernel/sysctl.c                     |   11 +++++++++++
>>  9 files changed, 101 insertions(+), 29 deletions(-)
>
>and more importantly it misses theese:
>>>   kernel/sched_autogroup.c            |  170
>>>   ++++++++++++++++++++++++++++++++++++ kernel/sched_autogroup.h      
>>>        |   23 ++++
>
>Wich means it wont build...

As I just found also.
>
>--
>Thomas

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Surprise your boss.  Get to work on time.

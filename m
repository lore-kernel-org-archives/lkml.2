Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159Ab0KRSkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:40:36 -0500
Received: from mbox1.netikka.net ([213.250.81.202]:51750 "EHLO
	mbox1.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab0KRSke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:40:34 -0500
Message-ID: <4CE5731B.20807@mandriva.org>
Date: Thu, 18 Nov 2010 20:40:27 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Galbraith patch
References: <1290018947.4887.14.camel@note-311a>	 <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>	 <AANLkTinRBvZQmeU-eEeDSd1ELvcxDZAdM6F8-UCROybq@mail.gmail.com>	 <1290021497.4887.24.camel@note-311a>	 <1290036097.27521.5.camel@maggy.simson.net>	 <1290095008.9939.0.camel@note-311a> <1290096365.30211.5.camel@maggy.simson.net>
In-Reply-To: <1290096365.30211.5.camel@maggy.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith skrev 18.11.2010 18:06:
> On Thu, 2010-11-18 at 13:43 -0200, Gilberto Nunes wrote:
>> Hi...
>>
>> Someone can help with this????
>
> Hey, patience please, I'm on vacation :)
>
> You can try the below if you like.  It's what I'm currently tinkering
> with, and has a patch it depends on appended for ease of application.
> Should apply cleanly to virgin 2.6.36.
>

[...]

This diffstat does not match the patch:
---
>   Documentation/kernel-parameters.txt |    2
>   include/linux/sched.h               |   19 ++++
>   init/Kconfig                        |   12 ++
>   kernel/fork.c                       |    5 -
>   kernel/sched.c                      |   13 ++
>   kernel/sched_autogroup.c            |  170 ++++++++++++++++++++++++++++++++++++
>   kernel/sched_autogroup.h            |   23 ++++
>   kernel/sched_debug.c                |   29 +++---
>   kernel/sys.c                        |    4
>   kernel/sysctl.c                     |   11 ++

It's really:
>  Documentation/kernel-parameters.txt |    2 ++
>  include/linux/sched.h               |   21 ++++++++++++++++++++-
>  init/Kconfig                        |   12 ++++++++++++
>  kernel/fork.c                       |    5 ++++-
>  kernel/sched.c                      |   21 +++++++++++++++------
>  kernel/sched_debug.c                |   29 +++++++++++++++--------------
>  kernel/sched_fair.c                 |   25 +++++++++++++++++++------
>  kernel/sys.c                        |    4 +++-
>  kernel/sysctl.c                     |   11 +++++++++++
>  9 files changed, 101 insertions(+), 29 deletions(-)

and more importantly it misses theese:
>>   kernel/sched_autogroup.c            |  170 ++++++++++++++++++++++++++++++++++++
>>   kernel/sched_autogroup.h            |   23 ++++

Wich means it wont build...

--
Thomas

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab1FMPuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:50:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:11325 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1FMPuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:50:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,359,1304319600"; 
   d="scan'208";a="13897041"
Message-ID: <4DF631CB.20209@linux.intel.com>
Date: Mon, 13 Jun 2011 08:50:35 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: peterz@infradead.org, eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, sbohrer@rgmadvisors.com,
        zvonler@rgmadvisors.com, hughd@google.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins> <4DF2099B.7030600@jp.fujitsu.com> <4DF25463.3080508@linux.intel.com> <4DF571C6.9040409@jp.fujitsu.com>
In-Reply-To: <4DF571C6.9040409@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/12/2011 07:11 PM, KOSAKI Motohiro wrote:
>>> Off topic: current futex documentations are near terribly unclear and
>>> many futex op are completely undocumented. They are one of root cause
>>> that every change can make compatibility issue. (;_;
>>
>> What documentation are you referring to? The futex man page is a wreck,
>> and I'm not sure what to do with it since glibc removed the futex()
>> call. You now have to wrap the syscall manually anyway.
> 
> Honestly, I don't know linux man pages policy at all. example, gettid(2)
> also need to be wrap syscall manually. and it's documented and NOTES section
> describe "Glibc does not provide a wrapper for this system call; call it
> using syscall(2)".

Something like that would be good. I don't have any experience pushing
man-page updates. This page seems to document the process:

http://www.kernel.org/doc/man-pages/

> 
> Or, if nobody want to update the doc, shouldn't we just remove futex(2) man
> pages? out date docs are often wrong than nothing. I dunno.

I'd prefer to see it updated as I know of several users of the interface
outside of glibc.

> 
> 
>> If you are referring to the futex.c file itself, I have been documenting
>> functions as I modify them. If you found any of those lacking, please
>> let me know which ones and I'll try to clean them up. If you're
>> referring to those that remain undocumented, please send a doc patch and
>> I'll review and help get it upstream. I'd like to see this improved as well.
> 
> No. I think the comments of futex.c are very good, at least, than a lot of mm code. ;)
> 
> 

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

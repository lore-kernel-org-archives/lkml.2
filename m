Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1FJR3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:29:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:62647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755147Ab1FJR3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:29:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,348,1304319600"; 
   d="scan'208";a="12095105"
Message-ID: <4DF25463.3080508@linux.intel.com>
Date: Fri, 10 Jun 2011 10:29:07 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: peterz@infradead.org, eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, sbohrer@rgmadvisors.com,
        zvonler@rgmadvisors.com, hughd@google.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins> <1307376989.2322.171.camel@twins> <4DF2099B.7030600@jp.fujitsu.com>
In-Reply-To: <4DF2099B.7030600@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/10/2011 05:10 AM, KOSAKI Motohiro wrote:

> 
> Off topic: current futex documentations are near terribly unclear and
> many futex op are completely undocumented. They are one of root cause
> that every change can make compatibility issue. (;_;

What documentation are you referring to? The futex man page is a wreck,
and I'm not sure what to do with it since glibc removed the futex()
call. You now have to wrap the syscall manually anyway.

If you are referring to the futex.c file itself, I have been documenting
functions as I modify them. If you found any of those lacking, please
let me know which ones and I'll try to clean them up. If you're
referring to those that remain undocumented, please send a doc patch and
I'll review and help get it upstream. I'd like to see this improved as well.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

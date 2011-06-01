Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab1FACM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:12:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:52476 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933096Ab1FACM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:12:58 -0400
X-ExtLoop1: 1
Message-ID: <4DE5A028.4050008@linux.intel.com>
Date: Tue, 31 May 2011 19:12:56 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Paul McQuade <tungstentide@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] KERNEL: async: Fixed an include coding style issue
References: <4DE596B4.7030904@gmail.com> <1306892552.10135.16.camel@gandalf.stny.rr.com>
In-Reply-To: <1306892552.10135.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/2011 6:42 PM, Steven Rostedt wrote:
> I should have told you to Cc this change to Arjan (as I just did), as he
> owns this file.
>
> -- Steve
>
>
> On Wed, 2011-06-01 at 02:32 +0100, Paul McQuade wrote:
>> > From 2514174efe73e654c46e669ea2df5169a41d0130 Mon Sep 17 00:00:00 2001
>> From: Paul McQuade<tungstentide@gmail.com>
>> Date: Tue, 31 May 2011 20:51:55 +0100
>> Subject: [PATCH] KERNEL: async: Fixed an include coding style issue
>>
>> async:
>> Added<linux/atomic.h>,<linux/ktime.h>  and Removed<asm/atomic.h>.
>> Added KERN_DEBUG to printk() functions.
>>
>> Signed-off-by: Paul McQuade<tungstentide@gmail.com>

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


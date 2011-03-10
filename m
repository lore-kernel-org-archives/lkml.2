Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1CJRuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 12:50:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:51818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab1CJRug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 12:50:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,297,1297065600"; 
   d="scan'208";a="895938263"
Message-ID: <4D790F4B.2030908@linux.intel.com>
Date: Thu, 10 Mar 2011 09:50:03 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>	 <1299715137-22768-3-git-send-email-dhsharp@google.com>	 <4D7828F9.7000906@linux.intel.com>	 <1299720997.15854.276.camel@gandalf.stny.rr.com>	 <4D783038.8080103@linux.intel.com>	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>	 <4D787312.7080609@linux.intel.com> <1299762670.15854.332.camel@gandalf.stny.rr.com>
In-Reply-To: <1299762670.15854.332.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/10/2011 05:11 AM, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 22:43 -0800, Darren Hart wrote:
>
>>> I don't know the answers, but if we take the kernel Makefile as a
>>> template, then setting CC doesn't work.
>>
>> The kernel is a bit special I believe as it is pretty tied to gcc. Is
>> trace-cmd tied to gcc to such a degree that we want to make it difficult
>> for people to try different compilers?
>
> True, trace-cmd is tied more to glibc (special features) than gcc.
>
> I just looked at the Makefile for evolution, and it has:
>
> CC = gcc
>
> So it is not limited to just the kernel.

I think we're down to a subjective argument over "correctness". Any of 
the resent proposals will work for me.


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel

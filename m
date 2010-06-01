Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0FADWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:22:37 -0400
Received: from mail.tmr.com ([64.65.253.246]:34282 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab0FADWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:22:36 -0400
Message-ID: <4C047CF9.9000804@tmr.com>
Date: Mon, 31 May 2010 23:22:33 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Giangiacomo Mariotti <gg.mariotti@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Possible bug in 2.6.34 slub
References: <AANLkTimEFy6VM3InWlqhVooQjKGSD3yBxlgeRbQC2r1L@mail.gmail.com> <20100531165528.35a323fb.rdunlap@xenotime.net>
In-Reply-To: <20100531165528.35a323fb.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 1 Jun 2010 01:39:43 +0200 Giangiacomo Mariotti wrote:
> 
>> Hi, I've recently noticed this line on the dmesg output(kernel 2.6.34):
>> [    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
>> CPUs=16, Nodes=1
>>
>> My cpu is an I7 920, so it has 4 cores and there's hyperthreading
>> enabled, so there are 8 logical cpus. Is this a bug?
> 
> 
> No, it's just some boot/init time information.
> 
I would consider it a bug to claim CPUs=xx when xx is something other than the 
number of cores or the number of SMT threads supported by the processor. Of 
course if /proc/cpuinfo shows four siblings per core or something exciting, then 
it's right and you have a CPU you can sell to gizmodo and tell them a drunk left 
on the bar.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

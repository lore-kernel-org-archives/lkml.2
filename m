Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0C3MOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:14:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:34633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab0C3MOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:14:17 -0400
Message-ID: <4BB1EBD4.9030707@kernel.org>
Date: Tue, 30 Mar 2010 21:17:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 14/17] input: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>	<1269885165-18617-15-git-send-email-tj@kernel.org> <20100330142148.2ac3fc0e.sfr@canb.auug.org.au>
In-Reply-To: <20100330142148.2ac3fc0e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 12:14:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/30/2010 12:21 PM, Stephen Rothwell wrote:
>> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
>> index 532c56c..593562d 100644
>> --- a/drivers/char/sysrq.c
>> +++ b/drivers/char/sysrq.c
>> @@ -41,7 +41,7 @@
>>  #include <linux/hrtimer.h>
>>  #include <linux/oom.h>
>>  #include <linux/input.h>
>> -#include <linux/gfp.h>
>> +#include <linux/slab.h>
>>  
>>  #include <asm/ptrace.h>
>>  #include <asm/irq_regs.h>
> 
> This patch does not apply to the input tree.  That tree does not have the 
> #include <linux/gfp.h>
> line (your tree (slabh) adds that later in the linux-next cycle).

Ah, I see.  sysrq.c's requirement changed between mainline and
linux-next.  I'll update slabh tree such that it includes slab.h from
there.

Thanks.

-- 
tejun

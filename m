Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0IPJxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:53:52 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:47885 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab0IPJxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:53:51 -0400
X-Sasl-enc: AiXR9iMj0BBn32+Ia2wnnbEt3eVzbIjzr63VK4pUMasG 1284630831
Message-ID: <4C91E92C.6030005@eml.cc>
Date: Thu, 16 Sep 2010 11:53:48 +0200
From: Martin Kepplinger <martinkepplinger@eml.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100826 Lightning/1.0b1 Thunderbird/3.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: johnstul@us.ibm.com, damm@opensource.se, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] [BISECTED] System gets unresponsive since 2.6.35-rc1
References: <4C90A228.1050809@eml.cc> <alpine.LFD.2.00.1009151309100.2416@localhost6.localdomain6> <4C90DF2B.2020505@eml.cc> <alpine.LFD.2.00.1009151719410.2416@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009151719410.2416@localhost6.localdomain6>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2010-09-15 17:21, schrieb Thomas Gleixner:
> Martin,
> 
> On Wed, 15 Sep 2010, Martin Kepplinger wrote:
>> Am 2010-09-15 13:14, schrieb Thomas Gleixner:
>>> commit 54ff7e595d763d894104d421b103a89f7becf47c
>>> Author: Thomas Gleixner <tglx@linutronix.de>
>>> Date:   Tue Sep 14 22:10:21 2010 +0200
>>>
>>>     x86: hpet: Work around hardware stupidity
>>>     
>>
>> I tested this against 2.6.35. Since I can write this after watching half an
>> hour of LinuxCon Videos, this fixes the problem. I hope it to get merged soon.
>> I'll test it against the current tree as well and will stay happy and quiet as
>> long as I can't find a problem.
>>
>> Thanks a lot!
> 
> Thanks for testing! Could you please test the patch below on top of
> this one as well ?
> 
> Thanks,
> 
> 	tglx
> ---
> Subject: x86: hpet: Avoid the readback penalty
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Wed, 15 Sep 2010 14:32:17 +0200
> 

Both patches tested against 2.6.36. My system seems very stable.

Thank you,

	Martin

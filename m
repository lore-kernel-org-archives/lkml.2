Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab0IWUrC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:47:02 -0400
Received: from borg.medozas.de ([188.40.89.202]:55604 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab0IWUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:47:01 -0400
Date: Thu, 23 Sep 2010 22:46:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "Glove box" BIOS patch causes boot flicker
In-Reply-To: <4C9BB1C5.80808@zytor.com>
Message-ID: <alpine.LNX.2.01.1009232243110.21529@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1009220135380.25692@obet.zrqbmnf.qr> <4C994F0B.6030004@linux.intel.com> <alpine.LNX.2.01.1009232052230.16976@obet.zrqbmnf.qr> <4C9BB1C5.80808@zytor.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2010-09-23 22:00, H. Peter Anvin wrote:
>On 09/23/2010 11:54 AM, Jan Engelhardt wrote:
>> On Wednesday 2010-09-22 02:34, H. Peter Anvin wrote:
>> 
>>> There were some minor bugs (typos) in the conversion to the glove box 
>>> coding style. The ones we have found have been fixed, so the first 
>>> thing is to try the current mainline or the current tip tree.  
>>> Otherwise I would look for issues where either the wrong register is 
>>> changed, or something like a variable is changed instead of a field.
>> 
>> I tried v2.6.36-rc5 now, and it looks better. The cursor position is 
>> retained as desired. The mode switch is still there, albeit much 
>> shorter than it used to be.
>
>The mode switch was there in the original code.

That may very well be so, but there clearly is distinguished behavior 
w.r.t. that in 2.6.36 compared to .30.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0FGBNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:13:18 -0400
Received: from mx6.orcon.net.nz ([219.88.242.56]:32786 "EHLO mx6.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0FGBNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:13:15 -0400
Message-ID: <4C0C47A8.1000800@orcon.net.nz>
Date: Mon, 07 Jun 2010 13:13:12 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org
Subject: Re: 2.6.35-rc2 compilation error on Alpha
References: <4C0C22C4.3010705@orcon.net.nz> <AANLkTim9aWVzb7v5fnS6x3ghMU2_tpaLlbZu3SKXV_0R@mail.gmail.com>
In-Reply-To: <AANLkTim9aWVzb7v5fnS6x3ghMU2_tpaLlbZu3SKXV_0R@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-DSPAM-Check: by mx6.orcon.net.nz on Mon, 07 Jun 2010 13:13:13 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jun  7 13:13:13 2010
X-DSPAM-Confidence: 0.6528
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/10 12:08, Matt Turner wrote:
> On Sun, Jun 6, 2010 at 6:35 PM, Michael Cree<mcree@orcon.net.nz>  wrote:
>> When compiling 2.6.35-rc2 for Alpha architecture the following compiler
>> error is seen:
>>
>>   CC      arch/alpha/kernel/asm-offsets.s
>> In file included from include/linux/kernel.h:17,
>>                  from include/linux/sched.h:54,
>>                  from arch/alpha/kernel/asm-offsets.c:9:
>> include/linux/bitops.h: In function ‘hweight_long’:
>> include/linux/bitops.h:49: error: implicit declaration of function
>> ‘__arch_hweight32’
>
> Yeah, it was a stupid typo in
> 1527bc8b928dd1399c3d3467dd47d9ede210978a. I've fixed it and put the
> patch in my tree for Linus.

Ah, now the offending commit is pointed out to me I can see the trivial 
fix.  With that, as you say, compilation now bombs out in the pci-sysfs 
stuff.  Since you claim to have that in hand I'll await your solution.

Cheers
Michael.

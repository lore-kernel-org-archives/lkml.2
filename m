Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1E1T4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 15:56:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52238 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab1E1T4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 15:56:44 -0400
Message-ID: <4DE15373.8050708@landley.net>
Date: Sat, 28 May 2011 14:56:35 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
References: <4DDB5673.5060206@landley.net> <20110524143937.GB30117@linux-mips.org> <4DDCB1EB.4020707@landley.net> <20110527075512.GE30117@linux-mips.org> <20110527140011.GF30117@linux-mips.org> <4DE0D303.8000106@landley.net> <20110528162807.GB7150@linux-mips.org>
In-Reply-To: <20110528162807.GB7150@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2011 11:28 AM, Ralf Baechle wrote:
> On Sat, May 28, 2011 at 05:48:35AM -0500, Rob Landley wrote:
> 
>> Your missing hunk at the top of this file is:
>>
>> @@ -29,6 +29,7 @@
>>  #include <asm/system.h>
>>  #include <asm/cacheflush.h>
>>  #include <asm/traps.h>
>> +#include <asm/smp-ops.h>
>>
>>  #include <asm/gcmpregs.h>
>>  #include <asm/mips-boards/prom.h>
>>
>> And then the patch works!  Yay!  Thank you.
> 
> Thanks Rob!  I fixed that and the patch is now in the MIPS git.
> 
>   Ralf

Do you think it's a candidate for stable?

Ro

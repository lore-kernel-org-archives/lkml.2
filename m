Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1GVTL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:11:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37957 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1GVTL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:11:57 -0400
Message-ID: <4E29CB4A.40508@zytor.com>
Date: Fri, 22 Jul 2011 12:11:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] asm-generic: delay.h fix udelay and ndelay for 8
 bit args
References: <1310986975.21015.13.camel@needafix>	 <1310997937-26771-1-git-send-email-jonas@southpole.se> <1311361492.2660.13.camel@localhost>
In-Reply-To: <1311361492.2660.13.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2011 12:04 PM, Jonas Bonn wrote:
> 
> On Mon, 2011-07-18 at 16:05 +0200, Jonas Bonn wrote:
>> From: Andrew Morton <akpm@linux-foundation.org>
>>
>> With a non-constant 8-bit argument, a call to udelay() generates a warning:
>>
> <snip>
> 
>> ---
>>
>> Here's a patch that should resolve the merge conflict.  This applies
>> Andrew's changes on top of the new asm-generic/delay.h instead of the x86
>> arch-specific one.  I've tested this for OpenRISC and the changed macros
>> don't cause any problems there.
>>
>> Let me know if this is OK and I'll throw it into the OpenRISC tree together
>> with the other delay.h modifications.
>>
> 
> I haven't gotten any feedback on this... since the change looks
> appropriate to merge with the other changes to asm-generic/delay.h, I'll
> apply this patch there and carry the patch together with the other
> asm-generic/delay.h changes in the 'openrisc' tree.  Andrew can drop the
> patch from his series to avoid the merge conflict.
> 
> I hope that works for everybody...
> 

You may want to Cc: Arnd on this, since he's the asm-generic maintainer.

Otherwise, since this is zero work on our part, it obviously works for me.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


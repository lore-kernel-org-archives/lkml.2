Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0EQRGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 13:06:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55777 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0EQRGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 13:06:03 -0400
Message-ID: <4BF17769.4050906@zytor.com>
Date: Mon, 17 May 2010 10:05:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hpet: Add reference to chipset erratum documentation
 for disable-hpet-msi-quirk
References: <20100517164324.GB10254@alberich.amd.com> <alpine.LFD.2.00.1005170952080.4195@i5.linux-foundation.org> <4BF175FE.2010904@zytor.com>
In-Reply-To: <4BF175FE.2010904@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 09:59 AM, H. Peter Anvin wrote:
> On 05/17/2010 09:52 AM, Linus Torvalds wrote:
>>
>>
>> On Mon, 17 May 2010, Andreas Herrmann wrote:
>>>
>>> (At the moment the "SB700 Family Product Errata" document is available
>>> at http://support.amd.com/us/Embedded_TechDocs/46837.pdf)
>>
>> Ok, this is against x86 -tip, right? It doesn't apply for me, so I'll just 
>> assume I will get it through the normal x86 merge requests.
>>
> 
> It conflicts with a related change in -tip, but I'll fix it up and
> you'll get it with the usual merge window flood.
> 

Slight correction: it didn't conflict, it was based upon.  Anyway, it's
queued up in -tip now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


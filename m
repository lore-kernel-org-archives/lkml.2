Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab1FASOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 14:14:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50780 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976Ab1FASOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 14:14:19 -0400
Message-ID: <820d76c11c182f41dcbc652926e27d94.squirrel@www.skyhub.de>
In-Reply-To: <4DE59E9E.5030802@zytor.com>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
    <4DE59E9E.5030802@zytor.com>
Date: Wed, 1 Jun 2011 20:14:16 +0200 (CEST)
Subject: Re: [PATCH 0/4] Some x86, asm cleanups
From: "Borislav Petkov" <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Ingo Molnar" <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 June, 2011 4:06 am, H. Peter Anvin wrote:
> On 05/31/2011 01:21 PM, Borislav Petkov wrote:
>> Hi,
>>
>> here are a couple of asm cleanups. I hope I don't break some esoteric
>> gas version with them. They survived booting into kvm and on a couple of
>> different machines so I might get lucky.
>>
>> Suggestions welcome, as always.
>>
>> Thanks.
>
> Any way you can try them out on the gas version from hell[TM], a.k.a.
> 2.16?

I think by that you mean this guy:

 as --version
GNU assembler 2.16.91.0.5 20051219 (SUSE Linux)
Copyright 2005 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License.  This program has absolutely no warranty.
This assembler was configured for a target of `x86_64-suse-linux'.

at least this is one incarnation of it. I had to install SLES10 SP3
with the unpatched binutils version in kvm to test. And yes, the kernel
builds fine. Let me know if I should run some randconfigs, in addition.

Btw, I'm keeping the kvm image for future testing with the bat from hell :).

-- 
Regards/Gruss,
Boris.


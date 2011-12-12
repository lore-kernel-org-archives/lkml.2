Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1LLR31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:29:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40387 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1LLR3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:29:23 -0500
Message-ID: <4EE639E2.6060307@zytor.com>
Date: Mon, 12 Dec 2011 09:29:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com> <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com> <86sjkpiw8i.fsf@sumi.keithp.com> <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com> <86mxaxiu34.fsf@sumi.keithp.com>
In-Reply-To: <86mxaxiu34.fsf@sumi.keithp.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 09:21 AM, Keith Packard wrote:
> On Mon, 12 Dec 2011 08:50:52 -0800, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> 
>> Ahh. And the reason it works for me is that I don't even have 
>> "CONFIG_EFI" enabled, much less EFI debugging. So I never trigger
>> the buggy code at all.
> 
> I foolishly assumed that an EFI machine required CONFIG_EFI...
> 

Machines with EFI only do.

Machines which support BIOS emulation don't (and are generally better
off booted in that mode...)

It depends mostly if you have and EFI or a BIOS bootloader.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


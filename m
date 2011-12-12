Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1LLRK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:10:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1LLRKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:10:22 -0500
Message-ID: <4EE63563.6050407@zytor.com>
Date: Mon, 12 Dec 2011 09:09:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Keith Packard <keithp@keithp.com>, Matt Fleming <matt@console-pimps.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
References: <1323648762-2148-1-git-send-email-keithp@keithp.com> <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com> <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com> <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com> <86sjkpiw8i.fsf@sumi.keithp.com> <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
In-Reply-To: <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 08:50 AM, Linus Torvalds wrote:
> On Mon, Dec 12, 2011 at 8:35 AM, Keith Packard <keithp@keithp.com> wrote:
>>
>> Happy to oblige. Here's the first few seconds (until X starts):
> 
> Ahh. And the reason it works for me is that I don't even have
> "CONFIG_EFI" enabled, much less EFI debugging. So I never trigger the
> buggy code at all.
> 
> That certainly explains why I never saw the problem,
> 

Indeed it does.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


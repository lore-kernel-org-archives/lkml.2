Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1LLRiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:38:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48166 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1LLRiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <4EE639E2.6060307@zytor.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
 <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
 <867h22jwj1.fsf@sumi.keithp.com> <4EE575E3.7090206@zytor.com>
 <8639cqjvyn.fsf@sumi.keithp.com> <1323684083.3669.15.camel@mfleming-mobl1.ger.corp.intel.com>
 <86sjkpiw8i.fsf@sumi.keithp.com> <CA+55aFzkq-3z3URp75LkVd=Qk1nEk76wDZCrLPKyabNcdieQVA@mail.gmail.com>
 <86mxaxiu34.fsf@sumi.keithp.com> <4EE639E2.6060307@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Dec 2011 09:37:40 -0800
X-Google-Sender-Auth: GJr9il-4tZLPCUU3BbixMxzR5Nk
Message-ID: <CA+55aFw_1TMd6Ze5aqiZEyEqb6F=z4kMKWBYk4Wtx7G4-5rtiA@mail.gmail.com>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Keith Packard <keithp@keithp.com>, Matt Fleming <matt@console-pimps.org>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 9:29 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Machines with EFI only do.

Yeah, and they exist, but should basically be considered broken.

EFi without BIOS emulation is such a crazy idiotic crock that it's not
even funny. It's pure and utter shite.

EFI as a "extended BIOS rewritten in C" is not bad.

EFI as a "new world order" is totally idiotic and crazy, and only
morons ever believed it was a good idea.

Sadly that "pure EFI" thing still exists. Some of the early EFI
proponents really wanted it, and it's still an option for some
unfathomable reason. The world would be a better place without it.

                           Linus

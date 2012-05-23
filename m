Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab2EWQyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:54:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63440 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506Ab2EWQy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FBD1493.7000104@zytor.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
 <20120523161932.GN14757@aftab.osrc.amd.com> <1337790571.9783.28.camel@laptop>
 <4FBD10D5.6080602@zytor.com> <CA+55aFx383ZXZPrbe+C2Cv=Rr=FsARfs8=OXs-B0hK4Dzb-QLg@mail.gmail.com>
 <4FBD1493.7000104@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 09:54:06 -0700
X-Google-Sender-Auth: YrSD1eSZYqbeYuefoyvWpRuYKbw
Message-ID: <CA+55aFxxMTQVoFQkgViBR-pmcpWrmvtHzV=yT-vfaWJ1eXZf0w@mail.gmail.com>
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <borislav.petkov@amd.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 9:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Any reason we can't just tell people to use BIT() for a native "unsigned
> long" type (32/64 bits) and BIT_64() if they really want a 64-bit result?

Well, that's what we're doing now. And it seems to have resulted in
repeated bugs for architectures where most of the developers run on
64-bit machines, but the same code is actually supposed to work on
32-bit too (ie x86).

                   Linus

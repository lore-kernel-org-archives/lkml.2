Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab1HPHTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:19:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58059 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab1HPHTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:19:30 -0400
MIME-Version: 1.0
In-Reply-To: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
References: <a5a38901541cbe2805361c1887f2f395.squirrel@www.skyhub.de>
Date: Tue, 16 Aug 2011 12:49:28 +0530
Message-ID: <CAHSGOuuova1kB77_X6bQ3R7E5N2PLhGsmxqb6kd48EDZ9yEPug@mail.gmail.com>
Subject: Re: x86 memcpy performance
From: melwyn lobo <linux.melwyn@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, borislav.petkov@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, on 32-bit you're using the compiler-supplied version
> __builtin_memcpy when CONFIG_KMEMCHECK=n and your gcc is of version 4
> and above. Reportedly, using __builtin_memcpy generates better code.
>
> Btw, my version of SSE memcpy is 64-bit only.
>
> --
> Regards/Gruss,
> Boris.
>
>

We would rather use the 32 bit patch. Have you already got a 32 bit
patch. How can I use sse3 for 32 bit.
I don't think you have submitted 64 bit patch in the mainline.
Is there still work ongoing on this.

Regards,
Melwyn

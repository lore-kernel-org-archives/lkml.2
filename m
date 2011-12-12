Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1LLDAH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:00:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55712 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1LLDAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:00:05 -0500
MIME-Version: 1.0
In-Reply-To: <1323648762-2148-1-git-send-email-keithp@keithp.com>
References: <1323648762-2148-1-git-send-email-keithp@keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Dec 2011 18:59:43 -0800
X-Google-Sender-Auth: JObhGBmhf6lPoyXPDVnWV3MgsdA
Message-ID: <CA+55aFydzKrzUaDtBaebjKKO4xVpubfZAXP6oSD-SDuDMq9eGw@mail.gmail.com>
Subject: Re: [PATCH] Revert "x86, efi: Calling __pa() with an ioremap()ed
 address is invalid"
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 11, 2011 at 4:12 PM, Keith Packard <keithp@keithp.com> wrote:
> This hangs my MacBook Air at boot time; I get no console messages at
> all. I reverted this on top of -rc5 and my machine boots again.

Interesting. Current -git works for me on my 11" Macbook Air. Which
should be identical to yours. This is the 4GB RAM, 128GB disk version,
no?

But I'm running OpenSUSE, and you're running Debian, right? And our
kernel configs are probably wildly different, since I tend to try to
boot a fairly minimal set.

That said, if you've verified that if fails for you, I guess we should
revert regardless. Matt, any suggestions for tests to do?

                       Linus

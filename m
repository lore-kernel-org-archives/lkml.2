Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096Ab1KBEUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 00:20:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52280 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1KBEUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 00:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <201111020322.46469.arnd@arndb.de>
References: <201111020322.46469.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Nov 2011 21:20:27 -0700
X-Google-Sender-Auth: 7OmNEwe5eD6Ac9ocu5hdvs00Y1Q
Message-ID: <CA+55aFzCyQ1fyTs5ZbcGD_gCVX0oA99NiLEsxMtJ1h9xf_-v9A@mail.gmail.com>
Subject: Re: [GIT PULL 0/13 (12)] arm-soc updates
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 7:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> I have a series of 12 pull requests for the arm-soc tree, a total of 409
> non-merge commits. Feel free to pull either the for-linus branch that contains
> the lot with all conflicts resolved or the individual pull requests.

Ok, I did the individual merges, because I really want to know what
horrible things go on there. Ugh.

But I did compare it against your pre-merged thing, and there are some
differences. I think my version of the arch/arm/mach-omap2/Makefile
thing is better, for example (you seem to have the OMAP4_PANDA and
OMAP3517EVM boards duplicated). And the arch/arm/plat-omap/devices.c
difference is just a matter of taste.

But the arch/arm/mach-omap2/board-generic.c difference is real. You
left a lot more header file includes in place, while my merge looked
at the previous commits and merges that removed a lot of them - and
followed suit. Maybe there was some reason you didn't? Also, your tree
removed the atag_offset lines that weren't even content conflicts, and
again, there may have been some reason for that?

But the differences ended up so small that I'm not worrying about it,
and I pushed it out. If there are issues with those differences,
holler (and send me a patch).

                    Linus

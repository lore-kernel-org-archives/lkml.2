Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2AKXWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 18:22:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48151 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2AKXWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 18:22:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
 <CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
 <7vty438575.fsf@alter.siamese.dyndns.org> <201201111812.46431.arnd@arndb.de> <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 15:21:46 -0800
X-Google-Sender-Auth: q8y8Y7Ea3_vzarbP7kf9QUrSSek
Message-ID: <CA+55aFxDdCUd_h2Xk3H3giO4GsAE05Y8-uN1tqRNOJiKV-mhGg@mail.gmail.com>
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Junio C Hamano <gitster@pobox.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 12:29 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> And all of this would look nice if you would have done a rebase on top of the
> latest tagged version of Linus' tree that contains all prerequisites, right?

Rebasing means that nobody else can depend on or work with that tree,
so it's a no-no.

Sure, it works if you are the only person touching it, but then you
had better not export it at all, so what's the point?

We have had independent problems in another branch exactly because it
was rebased and people merged it, so bringing up rebasing as a
"solution" is wrong-headed. It just causes *more* problems of other
kinds, even if it may make git request-pull trivial.

                        Linus

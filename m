Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab2AKU36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:29:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43841 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2AKU34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:29:56 -0500
MIME-Version: 1.0
In-Reply-To: <201201111812.46431.arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
	<CA+55aFw15sw0PWtom88vJx1M45CLuvpZABQAxMOQ+xowz8Xq2A@mail.gmail.com>
	<7vty438575.fsf@alter.siamese.dyndns.org>
	<201201111812.46431.arnd@arndb.de>
Date: Wed, 11 Jan 2012 21:29:55 +0100
X-Google-Sender-Auth: FwW25iqQxUFIA_mE0oJ2gcQh5co
Message-ID: <CAMuHMdVvQzdxw0B3ZMtJej=9Qwm7Qbd5aenSOfa=QPhX8UUt2w@mail.gmail.com>
Subject: Re: [GIT PULL 05/11] SoC-level changes for tegra and omap
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Junio C Hamano <gitster@pobox.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 19:12, Arnd Bergmann <arnd@arndb.de> wrote:

[...]

> Now let's assume that all dependencies are merged upstream already
> and I just want to send out three pull requests. The first
> pull request generally works fine, though it could be that some
> version of git in the past would include the diff between v3.3-rc2
> and v3.3-rc4 in the diffstat. For the second pull request, I merge
> v3.3 with A and send do 'git request-pull B origin
> tmp-merge-of-upstream-and-A'. This seems to generate the correct
> list of patches, but the wrong diffstat (diffstat also contains
> the diff between v3.3-rc4 and v3.3-rc5, although that is indeed
> part of tmp-merge-of-upstream-and-A. For submitting branch C,
> I have to merge upstream, A, B and the dependencies together
> and then send a pull request against that. This typically also
> includes the external dependencies in the diffstat.

<throwing the bat in the hen house, no idea if this expression exists
in other languages than Dutch>
And all of this would look nice if you would have done a rebase on top of the
latest tagged version of Linus' tree that contains all prerequisites, right?
</throwing...>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2GKQkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 12:40:01 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36621 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418Ab2GKQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 12:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUX565WsuJNHKsohXi=vp34Acn+2D-nj8mQQtCfi=Pw_Nw@mail.gmail.com>
References: <CA+icZUX565WsuJNHKsohXi=vp34Acn+2D-nj8mQQtCfi=Pw_Nw@mail.gmail.com>
Date: Wed, 11 Jul 2012 18:39:59 +0200
Message-ID: <CACRpkdbazoCztqbT00_oBsRyee=VBDH+NiGEpzNk8uV7mvsNwQ@mail.gmail.com>
Subject: Re: linux-next: Tree for July 10 (gpio/gpio-tps65910.c)
From: Linus Walleij <linus.walleij@linaro.org>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 2:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:

> I see the same build-error as Randy in latest linux.git
> (055c9fa8874fa7261eec7a268366565db84af474).

Yes, it is there.

> Where is this patch queued up (see original posting)?

Here:
http://git.kernel.org/?p=linux/kernel/git/linusw/linux-gpio.git;a=shortlog;h=refs/heads/fixes

> I do not see any patch in [2].

Grant asked me to take over for a while, 10 days ago.

> I also do not see any patch sent to LKML.

But there was such a patch:
http://lkml.org/lkml/2012/7/10/16

And it's queued in my tree and on the for-next branch.

And as noted, I also tried to send it to Linus (Torvalds)
as an update to my last pull request. I guess I'll just have
to send another request.

Yours,
Linus Walleij

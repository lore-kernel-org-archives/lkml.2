Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab2ELAdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:33:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53894 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761450Ab2ELAdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vtcOX4X7XYmgFguUUOVCQnHvG4SMu_NbjLgm_uRFeMfQ@mail.gmail.com>
References: <CACxGe6vtcOX4X7XYmgFguUUOVCQnHvG4SMu_NbjLgm_uRFeMfQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 May 2012 18:33:30 -0600
X-Google-Sender-Auth: _JmislxFfC6btDjs0U6epyWEyEQ
Message-ID: <CACxGe6v-=zmyJ-v4FyAZZd=UK0edfjSYQ8p6N5jeUbKNjUSkGg@mail.gmail.com>
Subject: Re: [GIT PULL] gpio bug fix for OMAP
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed a couple.  Here's an updated pull req for GPIO

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to 2760f7adbb6c4e39bd3ae733f56d4ac8fb5e3521:

  gpio/exynos: Fix compiler warnings when non-exynos machines are
selected (2012-05-11 18:25:53 -0600)

----------------------------------------------------------------
GPIO bug fixes on top of v3.4-rc6

An OMAP bug fix, a set of PCH bug fixes, and one patch to fix up compile
warnings

----------------------------------------------------------------
Sachin Kamat (1):
      gpio/exynos: Fix compiler warnings when non-exynos machines are selected

Tarun Kanti DebBarma (1):
      gpio/omap: fix incorrect initialization of omap_gpio_mod_init

Thomas Gleixner (1):
      gpio: pch9: Use proper flow type handlers

 drivers/gpio/gpio-omap.c    |    9 +++----
 drivers/gpio/gpio-pch.c     |   57 +++++++++++++++++++++----------------------
 drivers/gpio/gpio-samsung.c |   18 +++++++++-----
 3 files changed, 43 insertions(+), 41 deletions(-)

On Fri, May 11, 2012 at 5:56 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:
>
>  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus
>
> for you to fetch changes up to 6edd94db250038c8fdf176f23ca4017d2f312509:
>
>  gpio/omap: fix incorrect initialization of omap_gpio_mod_init
> (2012-05-10 07:16:15 -0700)
>
> ----------------------------------------------------------------
> GPIO omap bug fixes on top of v3.4-rc6
>
> ----------------------------------------------------------------
> Tarun Kanti DebBarma (1):
>      gpio/omap: fix incorrect initialization of omap_gpio_mod_init
>
>  drivers/gpio/gpio-omap.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

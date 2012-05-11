Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299Ab2EKX5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:57:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49997 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761166Ab2EKX5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:57:03 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 11 May 2012 17:56:38 -0600
X-Google-Sender-Auth: jFK8-vifQPvEMUmywQER0LZRQNA
Message-ID: <CACxGe6vtcOX4X7XYmgFguUUOVCQnHvG4SMu_NbjLgm_uRFeMfQ@mail.gmail.com>
Subject: [GIT PULL] gpio bug fix for OMAP
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 tags/gpio-for-linus

for you to fetch changes up to 6edd94db250038c8fdf176f23ca4017d2f312509:

  gpio/omap: fix incorrect initialization of omap_gpio_mod_init
(2012-05-10 07:16:15 -0700)

----------------------------------------------------------------
GPIO omap bug fixes on top of v3.4-rc6

----------------------------------------------------------------
Tarun Kanti DebBarma (1):
      gpio/omap: fix incorrect initialization of omap_gpio_mod_init

 drivers/gpio/gpio-omap.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

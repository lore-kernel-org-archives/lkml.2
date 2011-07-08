Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1GHPeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 11:34:00 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:37439 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1GHPdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 11:33:55 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 8 Jul 2011 09:33:34 -0600
X-Google-Sender-Auth: 2LpQfi2x3SuEsZlXtNnNavvdJEU
Message-ID: <CACxGe6t2u9U=3P7zgOszPWovm2oJdg=7O-K-EfEPaxMHtxD6fg@mail.gmail.com>
Subject: [GIT PULL] another gpio bugfix pull
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a2fa83faf47b514ab947cea916d3691b66525073:

  Merge branch 'usb-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
(2011-07-05 20:57:45 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Axel Lin (1):
      gpio: tps65910: add missing breaks in tps65910_gpio_init

Mathias Nyman (1):
      gpio/langwell_gpio: ack the correct bit for langwell gpio interrupts

 drivers/gpio/langwell_gpio.c |    2 +-
 drivers/gpio/tps65910-gpio.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

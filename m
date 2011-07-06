Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1GFWHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 18:07:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42751 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1GFWHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 18:07:49 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Jul 2011 16:07:28 -0600
X-Google-Sender-Auth: -LVH7hEfgKcPoRb7QlDd7rGAm1s
Message-ID: <CACxGe6tuiG29nqZX8qQaD64PY40WsnMdg1kXs8et6-jSnhgw+w@mail.gmail.com>
Subject: [GIT PULL] gpio bug fix for v3.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>
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

 drivers/gpio/tps65910-gpio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

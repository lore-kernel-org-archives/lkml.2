Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1FHPUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 11:20:15 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62265 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756386Ab1FHPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 11:20:12 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 8 Jun 2011 09:19:52 -0600
X-Google-Sender-Auth: Ih0CcpNPKVuZ_ZliL5MaI8y9MjY
Message-ID: <BANLkTikoe4JbRd5S6Weyi_054_1sRdh_dQ@mail.gmail.com>
Subject: [GIT PULL] gpio fixes for 3.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 gpio/merge

Colin Cross (2):
      GPIO: OMAP: fix setting IRQWAKEN bits for OMAP4
      GPIO: OMAP: add locking around calls to _set_gpio_triggering

Grant Likely (1):
      Merge branch 'for_3.0/gpio-fixes' of
git://git.kernel.org/.../khilman/linux-omap-pm into gpio/merge

H Hartley Sweeten (1):
      gpio/samsung: make Kconfig options def_bool

Kyungmin Park (1):
      gpio: Fix gpio-exynos4 build fails in mainline

Russell King (1):
      GPIO: OMAP: fix section mismatch warnings

Thomas Abraham (1):
      gpio/exynos4: Fix incorrect mapping of gpio pull-up macro to
register setting

 drivers/gpio/Kconfig        |   28 ++++++++--------------------
 drivers/gpio/gpio-exynos4.c |   29 +++++++++++++++++++++++++----
 drivers/gpio/gpio-omap.c    |   23 ++++++++++++-----------
 3 files changed, 45 insertions(+), 35 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

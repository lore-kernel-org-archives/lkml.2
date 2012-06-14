Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2FNHkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 03:40:37 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55201 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2FNHkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 03:40:35 -0400
MIME-Version: 1.0
Date: Thu, 14 Jun 2012 09:40:34 +0200
Message-ID: <CACRpkdZ8J9PEwCvm3ewE1RppmJC0sdOw0LSF+czUYrpUvhmhRA@mail.gmail.com>
Subject: [GIT PULL] pin control fixes for v3.5
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are a few pin control fixes for the v3.5 rc series, in a nice
signed tag with some
explanation of what is being fixed. Please pull them in!

Linus Walleij


The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-for-v3.5

for you to fetch changes up to 149ff9e1f240e7b57a02e0be5f74f21d0307d1d3:

  pinctrl: pinctrl-mxs: set platform driver data to NULL at errpath
and at unregister (2012-06-12 16:26:08 +0200)

----------------------------------------------------------------
pinctrl fixes for v3.5 rc series:
- section markup fixes
- clk_prepare() fix to conform to the clk API
- memory leaks
- incorrect debug messages
- bad errorpaths
- typos

----------------------------------------------------------------
Barry Song (1):
      pinctrl: sirf: mark of_device_id match table as __devinitconst

Devendra Naga (4):
      pinctrl: pinctrl-imx: free allocated pinctrl_map structure only
once and use kernel facilities for IMX_PMX_DUMP
      pinctrl: pinctrl-imx: free if of_get_parent fails to get the parent node
      pinctrl: pinctrl-mxs: Take care of frees if the kzalloc fails
      pinctrl: pinctrl-mxs: set platform driver data to NULL at
errpath and at unregister

Dong Aisheng (1):
      pinctrl: pinctrl-imx: fix incorrect debug message of maps

Guennadi Liakhovetski (1):
      pinctrl: fix a minor harmless typo

Linus Walleij (2):
      pinctrl: nomadik: add clk_prepare() call
      pinctrl: nomadik: fix up typo

 drivers/pinctrl/core.c            |    2 +-
 drivers/pinctrl/pinctrl-imx.c     |   34 ++++++++++++++++------------------
 drivers/pinctrl/pinctrl-mxs.c     |   13 ++++++++++---
 drivers/pinctrl/pinctrl-nomadik.c |    3 ++-
 drivers/pinctrl/pinctrl-sirf.c    |    2 +-
 5 files changed, 30 insertions(+), 24 deletions(-)

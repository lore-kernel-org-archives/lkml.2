Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab2HHOWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:22:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35067 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab2HHOWb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:22:31 -0400
MIME-Version: 1.0
Date: Wed, 8 Aug 2012 16:22:30 +0200
Message-ID: <CACRpkdYD-1MbJ2JmG8=zrtbWSEF4NJMWYdk4X+Z1gK+FQ1Mb0A@mail.gmail.com>
Subject: [GIT PULL] pinctrl fixes for v3.6-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are some pinctrl fixes for v3.6-rc1, info in the tag below.

Please pull them in!

The following changes since commit 0d7614f09c1ebdbaa1599a5aba7593f147bf96ee:

  Linux 3.6-rc1 (2012-08-02 16:38:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes-for-v3.6-rc1

for you to fetch changes up to 75c353ecacf54dbcca5e2e4388088893aac0fc34:

  drivers/pinctrl/pinctrl-nomadik.c: drop devm_kfree of devm_kzalloc'd
data (2012-08-07 14:34:12 +0200)

----------------------------------------------------------------
pinctrl fixes for v3.6-rc1:
- Move MXS pinctrl registration to poscore_initcall
- Fix up various devm_* managed resources code paths
- Fix one function group in the Nomadik driver
- Update MAINTAINERS

----------------------------------------------------------------
Devendra Naga (2):
      pinctrl/pinctrl-u300: remove unneeded devm_kfree call
      pinctrl-sirf: remove devm_kfree at error path

Julia Lawall (1):
      drivers/pinctrl/pinctrl-nomadik.c: drop devm_kfree of devm_kzalloc'd data

Patrice Chotard (1):
      pinctrl/nomadik: fix hsi function group list

Shawn Guo (1):
      pinctrl: mxs: register driver at postcore_initcall time

Uwe Kleine-König (1):
      MAINTAINERS: fix a few pinctrl related entries

 MAINTAINERS                              | 5 +++--
 drivers/pinctrl/pinctrl-imx23.c          | 2 +-
 drivers/pinctrl/pinctrl-imx28.c          | 2 +-
 drivers/pinctrl/pinctrl-nomadik-db8500.c | 2 +-
 drivers/pinctrl/pinctrl-nomadik.c        | 1 -
 drivers/pinctrl/pinctrl-sirf.c           | 1 -
 drivers/pinctrl/pinctrl-u300.c           | 8 ++------
 7 files changed, 8 insertions(+), 13 deletions(-)

Yours,
Linus Walleij

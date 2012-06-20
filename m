Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2FTH5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:57:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48879 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2FTH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:57:42 -0400
MIME-Version: 1.0
Date: Wed, 20 Jun 2012 09:57:41 +0200
Message-ID: <CACRpkdYU51vea8SQmm7-5DmC9FYBaJf_H-OdfreWS-x+xfEhHw@mail.gmail.com>
Subject: [GIT PULL] two pinctrl fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Devendra aaru <devendra.aaru@gmail.com>,
        fabio.estevam@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are two pinctrl fixes, hopefully the last for this release. The
first is a simple two-liner
compilation fix, the other is a pure documentation patch that slipped
off an earlier
patch set. They're on a signed tag as usual.

Please pull them in!

Yours,
Linus Walleij


The following changes since commit 485802a6c524e62b5924849dd727ddbb1497cc71:

  Linux 3.5-rc3 (2012-06-16 17:25:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-fixes

for you to fetch changes up to daf731748f978efb4f741d19b499236e03bf667f:

  pinctrl/nomadik: document Alt-C glitch (2012-06-17 19:44:44 +0200)

----------------------------------------------------------------
pinctrl fixes for the -rc series:
- Fixed a 2-line compile error for MXS
- A pure documentation fix for Nomadik

----------------------------------------------------------------
Fabio Estevam (1):
      pinctrl: mxs: Use kfree to fix build error

Linus Walleij (1):
      pinctrl/nomadik: document Alt-C glitch

 drivers/pinctrl/pinctrl-mxs.c     |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c |   22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

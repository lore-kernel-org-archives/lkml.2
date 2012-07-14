Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2GNXJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 19:09:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44886 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab2GNXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 19:09:47 -0400
MIME-Version: 1.0
Date: Sun, 15 Jul 2012 01:09:46 +0200
Message-ID: <CACRpkdaccJRftyQXBwyKFtTi0iRnQwVer0QRgDUrp88Oyfi6pw@mail.gmail.com>
Subject: [GIT PULL] two late pinctrl fixes
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dong Aisheng <B29396@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A last (hopefully) pull request from me, this is two late freescale i.MX
fixes for pinctrl, please pull them in:

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/fixes-for-v3.5-rc6

Dong Aisheng (2):
      pinctrl: pinctrl-imx: only print debug message when DEBUG is defined
      pinctrl: pinctrl-imx6q: add missed mux function for USBOTG_ID

 .../bindings/pinctrl/fsl,imx6q-pinctrl.txt         |    2 ++
 drivers/pinctrl/pinctrl-imx.c                      |    2 ++
 drivers/pinctrl/pinctrl-imx6q.c                    |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

Yours,
Linus Walleij

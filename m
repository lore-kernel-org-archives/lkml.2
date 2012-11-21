Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2KUP2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:28:13 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46934 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab2KUP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:28:11 -0500
MIME-Version: 1.0
Date: Wed, 21 Nov 2012 16:28:09 +0100
Message-ID: <CACRpkdYSPS+-0upDH6i90MpAUwnSmRE=FPWkYKmjyYG+VCrKSw@mail.gmail.com>
Subject: [GIT PULL] final pinctrl patch for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here a final (hopefully) oneliner for the pinctrl subsystem targeted at v3.7.

Please pull it in!

Yours,
Linus Walleij

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-v3.7-late

for you to fetch changes up to cbc351abe3c9bcec11c712dd41bb212748fd46d3:

  pinctrl/samsung: don't allow enabling pinctrl-samsung standalone
(2012-11-15 11:58:24 +0100)

----------------------------------------------------------------
A simple pinctrl Kconfig oneliner arriving late.

----------------------------------------------------------------
Arnd Bergmann (1):
      pinctrl/samsung: don't allow enabling pinctrl-samsung standalone

 drivers/pinctrl/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

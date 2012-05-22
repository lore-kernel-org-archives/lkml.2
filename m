Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2EVFhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:37:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2EVFhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:36 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 1/8] arm-soc: updates for MAINTAINERS file
Date: Mon, 21 May 2012 22:35:01 -0700
Message-Id: <1337664908-17478-2-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a collection of updates to the MAINTAINERS file, separated out
mostly to give an overview of what has changed regarding who does what.

In particular, at91, orion and prima2 platforms and drivers are updated
in this batch.

----------------------------------------------------------------

The following changes since commit 471368557a734c6c486ee757952c902b36e7fd01:

  Merge branch 'irq-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/maintainers

for you to fetch changes up to 47ac3e44cfd253a227734ed375435566ffddc173:

  MAINTAINER: add some drivers upstreamed in CSR SIRFPRIMA2

----------------------------------------------------------------

Arnd Bergmann (1):
      Merge tag 'at91-3.5-maintainers' of git://github.com/at91linux/linux-at91 into next/maintainers

Barry Song (1):
      MAINTAINER: add some drivers upstreamed in CSR SIRFPRIMA2

Josh Wu (2):
      MAINTAINERS: add entry for Atmel isi driver
      MAINTAINERS: add entry for Atmel touch screen ADC controller driver

Nicolas Ferre (3):
      MAINTAINERS: add entry for Atmel DMA driver
      MAINTAINERS: add entry for Atmel timer counter (TC)
      MAINTAINERS: remove non-responding web link for atmel_usba driver

Nicolas Pitre (1):
      maintainership update for the Marvell Orion family of SOCs


 MAINTAINERS | 43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

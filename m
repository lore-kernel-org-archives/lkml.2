Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab1BPUsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:48:02 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38625 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1BPUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:47:59 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Feb 2011 13:47:38 -0700
X-Google-Sender-Auth: AYYO868K-XNa7slUaIPHOjF5FcU
Message-ID: <AANLkTi=DH4fG-hv=mb8=RMPWPcqN57A-VcB1G7wvtFcA@mail.gmail.com>
Subject: [git pull] another spi bug fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a2640111d5edb3f4e6dd6089c0dbddc7590110b4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6
(2011-02-16 09:07:00 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 spi/merge

Sebastian Andrzej Siewior (1):
      spi/pxa2xx pci: fix the release - remove race

 drivers/spi/pxa2xx_spi_pci.c |   61 ++++++++++++++---------------------------
 1 files changed, 21 insertions(+), 40 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab2JJPr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab2JJPr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:47:57 -0400
Message-ID: <1349884075.2759.320.camel@ul30vt.home>
Subject: [GIT PULL] VFIO fixes for 3.7-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Wed, 10 Oct 2012 09:47:55 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 2474542f64432398f503373f53bdf620491bcfa8:

  Merge tag 'for-3.7-rc1' of git://gitorious.org/linux-pwm/linux-pwm (2012-10-10 20:15:24 +0900)

are available in the git repository at:


  git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.7-rc1

for you to fetch changes up to 899649b7d4ead76c19e39251ca886eebe3f811a8:

  vfio: Fix PCI INTx disable consistency (2012-10-10 09:10:32 -0600)

----------------------------------------------------------------
vfio fixes for v3.7-rc1

This includes a fix for PCI BAR mmaps after recent mm changes, fixing an
interrupt race, and fixing a consistency bug in interrupt state when
switching interrupt modes.

----------------------------------------------------------------
Alex Williamson (3):
      vfio: Fix PCI mmap after b3b9c293
      vfio: Move PCI INTx eventfd setting earlier
      vfio: Fix PCI INTx disable consistency

 drivers/vfio/pci/vfio_pci.c       |  7 +++----
 drivers/vfio/pci/vfio_pci_intrs.c | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 7 deletions(-)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2JDRAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab2JDRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:00:53 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] VFIO PCI INTx fixes
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Oct 2012 11:00:48 -0600
Message-ID: <20121004165917.4014.13849.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are now available in my next tree to fix a couple
issues with PCI INTx.  Thanks,

Alex

---

Alex Williamson (2):
      vfio: Fix PCI INTx disable consistency
      vfio: Move PCI INTx eventfd setting earlier


 drivers/vfio/pci/vfio_pci_intrs.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

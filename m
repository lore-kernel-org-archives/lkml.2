Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab1KKRG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:06:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1KKRG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:06:26 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 0/2] PCI: PRI/PASSID cleanup and fix
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Date: Fri, 11 Nov 2011 10:06:23 -0700
Message-ID: <20111111170319.32668.48479.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Joerg, here's a split patch, separating a bug
fix in the PASID code incorrectly using a reserved bit in
the capability register from the renaming consistency changes
that found the bug.  Thanks,

Alex

---

Alex Williamson (2):
      PCI: More PRI/PASID cleanup
      PCI: Enable is not exposed as a PASID capability


 drivers/pci/ats.c        |   70 +++++++++++++++++++++++-----------------------
 include/linux/pci_regs.h |   30 +++++++++++---------
 2 files changed, 51 insertions(+), 49 deletions(-)

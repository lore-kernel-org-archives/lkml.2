Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab2DKPvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:51:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058Ab2DKPvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:51:46 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 0/2] kvm: iommu unmap fixes
To: kvm@vger.kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, avi@redhat.com, jan.kiszka@siemens.com,
        mtosatti@redhat.com
Date: Wed, 11 Apr 2012 09:51:43 -0600
Message-ID: <20120411154536.13227.10413.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a documentation change only from the previous version.
After discussing it, there is a potential page leak as noted
in the updated changelog for the first patch.  Thanks,

Alex

---

Alex Williamson (2):
      kvm: unpin guest and free iommu domain after deassign last device
      kvm: unmap pages from the iommu when slots are removed


 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/assigned-dev.c  |    3 +++
 virt/kvm/iommu.c         |    8 +++++++-
 virt/kvm/kvm_main.c      |    5 +++--
 4 files changed, 19 insertions(+), 3 deletions(-)

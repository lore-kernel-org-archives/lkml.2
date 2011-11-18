Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1KRRuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:50:09 -0500
Received: from relay04ant.iops.be ([212.53.5.219]:48584 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1KRRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:50:06 -0500
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Nov 2011 12:50:06 EST
From: Bart Van Assche <bvanassche@acm.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] hv: Move Kconfig menu entry
Date: Fri, 18 Nov 2011 18:41:42 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
        James Bottomley <JBottomley@parallels.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
References: <201111181840.52672.bvanassche@acm.org>
In-Reply-To: <201111181840.52672.bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111181841.42636.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the "Device Drivers/Microsoft Hyper-V guest support"
menu entry up such that it appears immediately below virtio
(KVM and lguest guest driver support) instead of after a
hypervisor driver menu entry.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index b5e6f24..5afe5d1 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -116,6 +116,8 @@ source "drivers/vlynq/Kconfig"
 
 source "drivers/virtio/Kconfig"
 
+source "drivers/hv/Kconfig"
+
 source "drivers/xen/Kconfig"
 
 source "drivers/staging/Kconfig"
@@ -132,8 +134,6 @@ source "drivers/iommu/Kconfig"
 
 source "drivers/virt/Kconfig"
 
-source "drivers/hv/Kconfig"
-
 source "drivers/devfreq/Kconfig"
 
 endmenu
-- 
1.7.3.4


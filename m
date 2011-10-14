Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433Ab1JNH5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 03:57:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:54390 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1JNH5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 03:57:02 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org, Mihai Caraman <mihai.caraman@freescale.com>
Subject: [PATCH] drivers/virt: add ioctl for 32-bit compat on 64-bit to fsl-hv-manager
Date: Fri, 14 Oct 2011 02:56:51 -0500
Message-Id: <1318579011-17124-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mihai Caraman <mihai.caraman@freescale.com>

Add ioctl to Freescale hypervisor management driver for 32-bit user-space
applications running on 64-bit guests.

Signed-off-by: Mihai Caraman <mihai.caraman@freescale.com>
Acked-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/virt/fsl_hypervisor.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 3d91621..4939e0c 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -706,6 +706,7 @@ static const struct file_operations fsl_hv_fops = {
 	.poll = fsl_hv_poll,
 	.read = fsl_hv_read,
 	.unlocked_ioctl = fsl_hv_ioctl,
+	.compat_ioctl = fsl_hv_ioctl,
 };
 
 static struct miscdevice fsl_hv_misc_dev = {
-- 
1.7.3.4


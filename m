Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1IGVrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:47:51 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:51193 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab1IGVru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:47:50 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1315425280!15802307!768
X-Originating-IP: [216.166.12.69]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: dt3155v4l: pci_iomap returns a void __iomem * not a void *
Date: Wed, 7 Sep 2011 14:46:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <mchehab@redhat.com>,
        <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109071446.05882.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>

---

diff --git a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/dt3155v4l/dt3155v4l.h
index b0792b3..c064eba 100644
--- a/drivers/staging/dt3155v4l/dt3155v4l.h
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h
@@ -204,7 +204,7 @@ struct dt3155_priv {
 	spinlock_t lock;
 	unsigned int field_count;
 	struct dt3155_stats stats;
-	void *regs;
+	void __iomem *regs;
 	int users;
 	u8 csr2, config;
 };

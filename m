Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab1CXEkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:40:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53449 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab1CXEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=L0uqXMxtTMJdUtSa+MKeum+BXIFDhD0MBYA6erfeL9sDHt/xYSJRPBMJzQ8aa3USvH
         WopV1hopTpAdxe0ZgTMs3N8xZ/2y4QAoA/k/Idw3z8qQ1UP5cvUMUfe6YgZcpS5pT7te
         bbftMIiMOpZxdT8QY4GEKGfxAHhR8e0hJWOw0=
Subject: [PATCH] gpu: poulsbo: Use PCI_VDEVICE macro
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Lee, Chun-Yi" <jlee@novell.com>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 12:40:22 +0800
Message-ID: <1300941622.16642.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpu/stub/poulsbo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/stub/poulsbo.c b/drivers/gpu/stub/poulsbo.c
index 7edfd27..c7dfba9 100644
--- a/drivers/gpu/stub/poulsbo.c
+++ b/drivers/gpu/stub/poulsbo.c
@@ -22,8 +22,8 @@ enum {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
-	{0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108}, \
-	{0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109}, \
+	{PCI_VDEVICE(INTEL, 0x8108), CHIP_PSB_8108}, \
+	{PCI_VDEVICE(INTEL, 0x8109), CHIP_PSB_8109}, \
 	{0, 0, 0}
 };
 
-- 
1.7.1




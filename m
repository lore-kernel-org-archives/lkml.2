Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab2HHLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 07:33:21 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:1728
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757637Ab2HHLdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 07:33:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275ch8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah107ah)
From: Qiang Liu <qiang.liu@freescale.com>
To: <linux-doc@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <leoli@freescale.com>, Qiang Liu <qiang.liu@freescale.com>,
        Chris Ball <cjb@laptop.org>, Rob Landley <rob@landley.net>
Subject: [PATCH RESEND 2/2] mmc/doc: feature description of runtime bounce buffer size adjustment
Date: Wed, 8 Aug 2012 19:06:18 +0800
Message-ID: <1344423978-2138-2-git-send-email-qiang.liu@freescale.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1344423978-2138-1-git-send-email-qiang.liu@freescale.com>
References: <1344423978-2138-1-git-send-email-qiang.liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add feature description of attribute bounce buffer size.

Cc: Chris Ball <cjb@laptop.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
---
 Documentation/mmc/mmc-dev-attrs.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/mmc/mmc-dev-attrs.txt b/Documentation/mmc/mmc-dev-attrs.txt
index 22ae844..8299433 100644
--- a/Documentation/mmc/mmc-dev-attrs.txt
+++ b/Documentation/mmc/mmc-dev-attrs.txt
@@ -7,6 +7,8 @@ SD or MMC device.
 The following attributes are read/write.

 	force_ro		Enforce read-only access even if write protect switch is off.
+	bouncesz		Support dynamic adjustment of bounce buffer size at runtime,
+				from 4K to 4M, integer multiple of 512 bytes only.

 SD and MMC Device Attributes
 ============================
--
1.7.5.1



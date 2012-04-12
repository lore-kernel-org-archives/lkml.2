Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640Ab2DLSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:45:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50961 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761550Ab2DLSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:45:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 12 Apr 2012 20:45:21 +0200
From: Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: [PATCH 02/13] ARM: Add document to list devices with trivial DT
 description
In-reply-to: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, thomas.abraham@linaro.org,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, olof@lixom.net, kgene.kim@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Message-id: <1334256332-29867-3-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 1.7.9.1
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add arm/trivial-devices.txt to enumerate devices for which only
basic resources are provided (compat, address and irq line).

This is based on i2c's trivial-devices.txt by Olof Johansson.

Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 .../devicetree/bindings/arm/trivial-devices.txt    |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/trivial-devices.txt

diff --git a/Documentation/devicetree/bindings/arm/trivial-devices.txt b/Documentation/devicetree/bindings/arm/trivial-devices.txt
new file mode 100644
index 0000000..443814a
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/trivial-devices.txt
@@ -0,0 +1,10 @@
+This is a list of trivial devices that have simple device tree
+bindings, consisting only of a compatible field, an address and
+possibly an interrupt line.
+
+If a device needs more specific bindings, such as properties to
+describe some aspect of it, there needs to be a specific binding
+document for it just like any other devices.
+
+Compatible                      Vendor / Chip
+========================        =============
-- 
1.7.9.1


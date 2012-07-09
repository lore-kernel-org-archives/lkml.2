Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2GIDMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:12:50 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52991 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2GIDLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:11:37 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q693AkIk004184
From: Hayes Wang <hayeswang@realtek.com>
To: <dwmw2@infradead.org>, <ben@decadent.org.uk>
CC: <romieu@fr.zoreil.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: =?	?q?=5BPATCH=20firmware=204/4=5D=20rtl=5Fnic=3A=20add=20new=20firmware=20for=20RTL8168G?=
Date: Mon, 9 Jul 2012 11:11:52 +0800
Message-ID: <1341803512-1309-4-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341803512-1309-1-git-send-email-hayeswang@realtek.com>
References: <1341803512-1309-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=""
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File: rtl_nic/rtl8168g-1.fw
Version: 0.0.1

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 WHENCE                |    3 +++
 rtl_nic/rtl8168g-1.fw |  Bin 0 -> 4272 bytes
 2 files changed, 3 insertions(+)
 create mode 100644 rtl_nic/rtl8168g-1.fw

diff --git a/WHENCE b/WHENCE
index 8f2b610..1fb7951 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1816,6 +1816,9 @@ Version: 0.0.1
 File: rtl_nic/rtl8106e-1.fw
 Version: 0.0.1
 
+File: rtl_nic/rtl8168g-1.fw
+Version: 0.0.1
+
 Licence:
  * Copyright © 2011, Realtek Semiconductor Corporation
  *
diff --git a/rtl_nic/rtl8168g-1.fw b/rtl_nic/rtl8168g-1.fw
new file mode 100644
index 0000000000000000000000000000000000000000..dace1ea98c66de08107ee0857d8a8680d57d7898
GIT binary patch
literal 4272
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

literal 0
HcmV?d00001

-- 
1.7.10.2


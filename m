Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab1HJFmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 01:42:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60532 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1HJFmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 01:42:16 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p7A5fUu9010395
From: Hayes Wang <hayeswang@realtek.com>
To: <dwmw2@infradead.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?q?=5Blinux-firmware=202/2=5D=20rtl=5Fnic=3A=20add=20new=20firmware=20for=20RTL8111F?=
Date: Wed, 10 Aug 2011 13:41:02 +0800
X-BOX-Message-Id: p7A5fUu9010395
Message-ID: <1312954862-32708-2-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1312954862-32708-1-git-send-email-hayeswang@realtek.com>
References: <1312954862-32708-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Albert Kuo <albertk@realtek.com>

Add new firmware:
1. rtl_nic/rtl8168f-1.fw
   version: rtl8168f-1_0.0.1
2. rtl_nic/rtl8168f-2.fw
   version: rtl8168f-2_0.0.1

Signed-off-by: Albert Kuo <albertk@realtek.com>
---
 WHENCE                |    2 ++
 rtl_nic/rtl8168f-1.fw |  Bin 0 -> 2928 bytes
 rtl_nic/rtl8168f-2.fw |  Bin 0 -> 256 bytes
 3 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 rtl_nic/rtl8168f-1.fw
 create mode 100644 rtl_nic/rtl8168f-2.fw

diff --git a/WHENCE b/WHENCE
index 4b88f1f..2b63594 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1627,6 +1627,8 @@ File: rtl_nic/rtl8105e-1.fw
 File: rtl_nic/rtl8168e-1.fw
 File: rtl_nic/rtl8168e-2.fw
 File: rtl_nic/rtl8168e-3.fw
+File: rtl_nic/rtl8168f-1.fw
+File: rtl_nic/rtl8168f-2.fw
 
 Licence:
  * Copyright © 2011, Realtek Semiconductor Corporation
diff --git a/rtl_nic/rtl8168f-1.fw b/rtl_nic/rtl8168f-1.fw
new file mode 100644
index 0000000000000000000000000000000000000000..a0dd2e5dec0a73968b26e0d81b4542240dbc719d
GIT binary patch
literal 2928
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
K^Pf1kock9M(ey3=

literal 0
HcmV?d00001

diff --git a/rtl_nic/rtl8168f-2.fw b/rtl_nic/rtl8168f-2.fw
new file mode 100644
index 0000000000000000000000000000000000000000..f8b48c3b5d4d4a040dc9703235bce4799c1fb106
GIT binary patch
literal 256
zcmY+7!3qIU6ox+}+gXsA61S`@n0u~FlO48{Y%OMkl_Gh7c?3&KkK$3hfj7XpBKhld
zPXGV?9e~4en@W;yx-PRl+Y@8cSZpk!nb%yWqqAf&O`NmiY%!W;lig~aiP)rXjmXd?
zLpR_At(=e?YCP{4-B-@!74>79>a#Dv4H_OYImOEg-z(d1*R$<EHbgrHWvd_d$J8l8
a0QIZym;8Ss9#79l>II)Wc<1jQ{PY6x_bUMa

literal 0
HcmV?d00001

-- 
1.7.3.2


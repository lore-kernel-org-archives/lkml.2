Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1AYWpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:45:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40941 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab1AYWpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:45:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=b+u+GD/HPitS1rBv5H1o6Ml8cc1PA9dJsNGrHEe0MEtDlnC8wDiGQIg0yXZw032qaT
         /wIqGIfei+05n7caAVqG81aEsJnozvq8rSS/8RsY8HGbt7f6XEymi5Xy7yqPT6NGd73x
         9TdcTeAWsmzHD+PldQQ4yhi9bhtbQPhSws/To=
From: Larry Finger <Larry.Finger@lwfinger.net>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, chaoming_li@realsil.com.cn,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] linux-firmware: Add firmware file for Realtek RTL8192DE
Date: Tue, 25 Jan 2011 16:45:25 -0600
Message-Id: <1295995525-17219-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 WHENCE                  |    8 ++++++++
 rtlwifi/rtl8192defw.bin |  Bin 0 -> 20526 bytes
 2 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 rtlwifi/rtl8192defw.bin

diff --git a/WHENCE b/WHENCE
index 45567ec..1cbd0a6 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1506,6 +1506,14 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmware for details.
 
 --------------------------------------------------------------------------
 
+Driver: rtl8192de - Realtek 802.11n WLAN driver for RTL8192DE
+
+File: rtlwifi/rtl8192defw.bin
+
+Licence: Redistributable. See LICENCE.rtlwifi_firmware for details.
+
+--------------------------------------------------------------------------
+
 
 Driver: r8169 - RealTek 8169/8168/8101 ethernet driver.
 
diff --git a/rtlwifi/rtl8192defw.bin b/rtlwifi/rtl8192defw.bin
new file mode 100644
index 0000000000000000000000000000000000000000..d159deab7642f66809509d04943101a6629ce6fb
GIT binary patch
literal 20526
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

literal 0
HcmV?d00001

-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab0IIWox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:44:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61888 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab0IIWos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P3Zr9N5p/Amf68PiOAVun64Hz9y0lewU7IEh1zKkem1i2g0/TcGk30w30YUzgQcqe9
         TYL/ANJc55FrXsfxMf36q9+HQA0p+Zc9Gr2hijIZZcJVvQKkepjlEv8d9DfKC0L6qVsP
         68oVLPXh8EtaHWKJR0tXd7V+dpIdgyttg0kPk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 198/223]drivers/staging/asus_oled/README Update broken web addresses.
Date: Thu,  9 Sep 2010 15:44:57 -0700
Message-Id: <1284072309-8452-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
References: <1284072309-8452-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/asus_oled/README |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/asus_oled/README b/drivers/staging/asus_oled/README
index 96b9717..b6f77c5 100644
--- a/drivers/staging/asus_oled/README
+++ b/drivers/staging/asus_oled/README
@@ -2,7 +2,7 @@
     Driver for Asus OLED display present in some Asus laptops.
 
     The code of this driver is based on 'asusoled' program taken from
-    https://launchpad.net/asusoled/. I just wanted to have a simple
+    http://lapsus.berlios.de/asus_oled.html. I just wanted to have a simple
     kernel driver for controlling this device, but I didn't know how
     to do that. Now I know ;) Also, that program can not be used
     with usbhid loaded, which means no USB mouse/keyboard while
-- 
1.7.2.1


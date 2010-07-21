Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686Ab0GUGw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 02:52:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37470 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762617Ab0GUGwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 02:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KOmJ1gH6bXGJtxzDZMA6a9GXvNppH0luxGPsvIw04SHXfJ/IgfB4TpotwKnrQwmIWi
         ASZMtk34w7FRWiOLyxWldFTVlCUv+uxMIk8VDBdFrQMdfpF+K08Bw2dnJubEU2RZ+6CB
         5UHdhYoTjTcr1ha2zAFzi1+hPmc/HFiAnaxpE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Thomas Weber <thomas.weber.linux@googlemail.com>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH 43/43 v2]Documentation/hwmon/adm1026 update web address.
Date: Tue, 20 Jul 2010 23:53:03 -0700
Message-Id: <1279695183-465-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web address.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Thomas Weber <thomas.weber.linux@googlemail.com>
Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>

---
 Documentation/hwmon/adm1026 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/adm1026 b/Documentation/hwmon/adm1026
index f4327db..d8fabe0 100644
--- a/Documentation/hwmon/adm1026
+++ b/Documentation/hwmon/adm1026
@@ -6,7 +6,7 @@ Supported chips:
     Prefix: 'adm1026'
     Addresses scanned: I2C 0x2c, 0x2d, 0x2e
     Datasheet: Publicly available at the Analog Devices website
-               http://www.analog.com/en/prod/0,,766_825_ADM1026,00.html
+               http://www.onsemi.com/PowerSolutions/product.do?id=ADM1026
 
 Authors:
         Philip Pokorny <ppokorny@penguincomputing.com> for Penguin Computing
-- 
1.7.1.rc1.21.gf3bd6


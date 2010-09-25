Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab0IYAJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 20:09:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61114 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab0IYAJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 20:09:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Ozlj7WinFu2Kaqi3o/xqiY5BZvMZtP4bAGjbbj7z4T7CqwCYREQQEIb1qhR0QTw9eN
         i1oJ5GSMUx2/A2Hew9IiQUgyuSkisNcjJTvCbIC0kkx3Ji8BnNPbi9wnJXptG/3JsfCX
         opyMvRn4svx2WKjqKodh8yHe5U7gw+ZcK3ULA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        dri-devel@lists.freedesktop.org, linux-ide@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 2/3 v3]update web addresses in stagging
Date: Fri, 24 Sep 2010 17:08:56 -0700
Message-Id: <1285373337-10945-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1285373337-10945-1-git-send-email-justinmattock@gmail.com>
References: <1285373337-10945-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch, is a simple fix to a broken web address not using a period in it's
name. I'll leave this up to you guys if you want to use it...

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 .../comedi/drivers/addi-data/APCI1710_82x54.c      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_82x54.h      |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Chrono.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Dig_io.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.c     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_INCCPT.h     |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.c    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Inp_cpt.h    |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Pwm.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ssi.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Tor.h        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.c        |    2 +-
 .../comedi/drivers/addi-data/APCI1710_Ttl.h        |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.c     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_S5920.h     |    2 +-
 .../comedi/drivers/addi-data/addi_amcc_s5933.h     |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.c |    2 +-
 .../staging/comedi/drivers/addi-data/addi_common.h |    2 +-
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_APCI1710.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.c       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci035.h       |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1564.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci16xx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2016.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.h      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3xxx.h      |    2 +-
 50 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
index 60213d2..b59f2d4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.c
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
index 9698ae1..81346db 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_82x54.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
index fbc26a0..644bda4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
index a6898e4..07108f9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
index af1b9cd..cc3973d 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Dig_io.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
index 0e498e9..14b13ea 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
index 7b48110..358298b 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_INCCPT.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
index 204d798..3f9cfa2 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
index 61a21cc..31fbb0b 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Inp_cpt.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
index 148ce6f..8883e66 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
index bf1b4c3..d8ad0b9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Pwm.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
index 6360de5..0c890a9 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
index eb7f101..ef4d887 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ssi.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 344df94..7361d50 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
index 03a93cb..537d475 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
index de6f772..9e177f4 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
index c4f1134..adcab82 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Ttl.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
index 97c10aa..90e71e1 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
index 622a4ac..9afdb13 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_S5920.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
index 8ed19bc..35a3ea1 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index 5ed4b94..93d7c05 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index 1a28169..13621d4 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index e0213a9..0aa11a0 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
index d7d768e..b748efc 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
index 22b3e56..89c99eb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_APCI1710.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 1369e22..74012e0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
index 68db9c1..3c700c7 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
index faea003..6e06d9d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
index e29a72a..7114acb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1032.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index b3b9218..b5d7d98 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
index 0579033..647f9eb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 7948c41..70edc38 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
index 21c09ed..4472829 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index 4299ff5..806f76d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
index 0780c44..c91594d 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
index 8bc88ad..8ebb254 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci16xx.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
index 89783b1eb..7090c24 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
index 639944c..c42612a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2016.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index d7d2223..73802ab 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
index c971d14..ab145e7 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
index e01889c..ced101f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
index 63e5f1f..83f42af 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2200.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index 851f71b..a813fdb 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
index fedfc9c..b3c8197 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h
@@ -9,7 +9,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index 560c848..5fd0303 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
index f3e7ebf..812a9c4 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index 4ed441a..517e9ab 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
index 743523e..63df635 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
index 2e20bc7..d3c5963 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.c
@@ -8,7 +8,7 @@ Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
 	D-77833 Ottersweier
 	Tel: +19(0)7223/9493-0
 	Fax: +49(0)7223/9493-92
-	http://www.addi-data-com
+	http://www.addi-data.com
 	info@addi-data.com
 
 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
index 788d7c1..cce9e12 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3xxx.h
@@ -6,7 +6,7 @@
  *	D-77833 Ottersweier
  *	Tel: +19(0)7223/9493-0
  *	Fax: +49(0)7223/9493-92
- *	http://www.addi-data-com
+ *	http://www.addi-data.com
  *	info@addi-data.com
  *
  * This program is free software; you can redistribute it and/or modify it
-- 
1.7.2.1


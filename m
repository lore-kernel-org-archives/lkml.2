Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2KPPUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 10:20:38 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:37263 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2KPPUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 10:20:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAJZZplBbdWOb/2dsb2JhbABEwmaBCIMMEoE+E4gRvi+MM4UNA5V8kEOCcA
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 1/2] Staging: ipack: adapt copyright to CERN guidelines
Date: Fri, 16 Nov 2012 16:19:58 +0100
Message-Id: <1353079199-11282-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt the copyright clause to CERN guidelines, as it has the copyright over
them.

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/carriers/tpci200.c |    7 ++++---
 drivers/staging/ipack/carriers/tpci200.h |    7 ++++---
 drivers/staging/ipack/devices/ipoctal.c  |    7 ++++---
 drivers/staging/ipack/devices/ipoctal.h  |    7 ++++---
 drivers/staging/ipack/devices/scc2698.h  |    7 ++++---
 drivers/staging/ipack/ipack.c            |    4 ++--
 drivers/staging/ipack/ipack.h            |    4 ++--
 7 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ipack/carriers/tpci200.c b/drivers/staging/ipack/carriers/tpci200.c
index 31cafff..c1a19b2 100644
--- a/drivers/staging/ipack/carriers/tpci200.c
+++ b/drivers/staging/ipack/carriers/tpci200.c
@@ -2,9 +2,10 @@
  * tpci200.c
  *
  * driver for the TEWS TPCI-200 device
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * Copyright (C) 2009-2012 CERN (www.cern.ch)
+ * Author: Nicolas Serafini, EIC2 SA
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/carriers/tpci200.h b/drivers/staging/ipack/carriers/tpci200.h
index 982f319..8d9be27 100644
--- a/drivers/staging/ipack/carriers/tpci200.h
+++ b/drivers/staging/ipack/carriers/tpci200.h
@@ -2,9 +2,10 @@
  * tpci200.h
  *
  * driver for the carrier TEWS TPCI-200
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * Copyright (C) 2009-2012 CERN (www.cern.ch)
+ * Author: Nicolas Serafini, EIC2 SA
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index b6a72e6..783f120 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -2,9 +2,10 @@
  * ipoctal.c
  *
  * driver for the GE IP-OCTAL boards
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * Copyright (C) 2009-2012 CERN (www.cern.ch)
+ * Author: Nicolas Serafini, EIC2 SA
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/devices/ipoctal.h b/drivers/staging/ipack/devices/ipoctal.h
index c5b4ed4..28f1c42 100644
--- a/drivers/staging/ipack/devices/ipoctal.h
+++ b/drivers/staging/ipack/devices/ipoctal.h
@@ -2,9 +2,10 @@
  * ipoctal.h
  *
  * driver for the IPOCTAL boards
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+
+ * Copyright (C) 2009-2012 CERN (www.cern.ch)
+ * Author: Nicolas Serafini, EIC2 SA
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
index 96e8d8c..2ad6acd 100644
--- a/drivers/staging/ipack/devices/scc2698.h
+++ b/drivers/staging/ipack/devices/scc2698.h
@@ -2,9 +2,10 @@
  * scc2698.h
  *
  * driver for the IPOCTAL boards
- * Copyright (c) 2009 Nicolas Serafini, EIC2 SA
- * Copyright (c) 2010,2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * Copyright (c) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ *
+ * Copyright (C) 2009-2012 CERN (www.cern.ch)
+ * Author: Nicolas Serafini, EIC2 SA
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index 429696b..6d5079d 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -1,8 +1,8 @@
 /*
  * Industry-pack bus support functions.
  *
- * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ * Copyright (C) 2011-2012 CERN (www.cern.ch)
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 7ca8789..6760bfa 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -1,8 +1,8 @@
 /*
  * Industry-pack bus.
  *
- * (C) 2011 Samuel Iglesias Gonsalvez <siglesia@cern.ch>, CERN
- * (C) 2012 Samuel Iglesias Gonsalvez <siglesias@igalia.com>, Igalia
+ * Copyright (C) 2011-2012 CERN (www.cern.ch)
+ * Author: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
-- 
1.7.10.4


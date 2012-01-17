Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab2AQNXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 08:23:30 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:61987 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2AQNWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 08:22:22 -0500
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 23/50] ACPICA: Update all copyrights to 2012
Date: Tue, 17 Jan 2012 07:21:15 -0500
Message-id: <77848130e53b06c22fe37a7b6acbb82bb3e9bfba.1326802229.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.9.rc1
In-reply-to: <1326802902-21583-1-git-send-email-lenb@kernel.org>
References: <1326802902-21583-1-git-send-email-lenb@kernel.org>
In-reply-to: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
References: <553575f1ae048aa44682b46b3c51929a0b3ad337.1326802228.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Update all copyrights to 2012.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/acpica/accommon.h  |    2 +-
 drivers/acpi/acpica/acconfig.h  |    2 +-
 drivers/acpi/acpica/acdebug.h   |    2 +-
 drivers/acpi/acpica/acdispat.h  |    2 +-
 drivers/acpi/acpica/acevents.h  |    2 +-
 drivers/acpi/acpica/acglobal.h  |    2 +-
 drivers/acpi/acpica/achware.h   |    2 +-
 drivers/acpi/acpica/acinterp.h  |    2 +-
 drivers/acpi/acpica/aclocal.h   |    2 +-
 drivers/acpi/acpica/acmacros.h  |    2 +-
 drivers/acpi/acpica/acnamesp.h  |    2 +-
 drivers/acpi/acpica/acobject.h  |    2 +-
 drivers/acpi/acpica/acopcode.h  |    2 +-
 drivers/acpi/acpica/acparser.h  |    2 +-
 drivers/acpi/acpica/acpredef.h  |    2 +-
 drivers/acpi/acpica/acresrc.h   |    2 +-
 drivers/acpi/acpica/acstruct.h  |    2 +-
 drivers/acpi/acpica/actables.h  |    2 +-
 drivers/acpi/acpica/acutils.h   |    2 +-
 drivers/acpi/acpica/amlcode.h   |    2 +-
 drivers/acpi/acpica/amlresrc.h  |    2 +-
 drivers/acpi/acpica/dsargs.c    |    2 +-
 drivers/acpi/acpica/dscontrol.c |    2 +-
 drivers/acpi/acpica/dsfield.c   |    2 +-
 drivers/acpi/acpica/dsinit.c    |    2 +-
 drivers/acpi/acpica/dsmethod.c  |    2 +-
 drivers/acpi/acpica/dsmthdat.c  |    2 +-
 drivers/acpi/acpica/dsobject.c  |    2 +-
 drivers/acpi/acpica/dsopcode.c  |    2 +-
 drivers/acpi/acpica/dsutils.c   |    2 +-
 drivers/acpi/acpica/dswexec.c   |    2 +-
 drivers/acpi/acpica/dswload.c   |    2 +-
 drivers/acpi/acpica/dswload2.c  |    2 +-
 drivers/acpi/acpica/dswscope.c  |    2 +-
 drivers/acpi/acpica/dswstate.c  |    2 +-
 drivers/acpi/acpica/evevent.c   |    2 +-
 drivers/acpi/acpica/evglock.c   |    2 +-
 drivers/acpi/acpica/evgpe.c     |    2 +-
 drivers/acpi/acpica/evgpeblk.c  |    2 +-
 drivers/acpi/acpica/evgpeinit.c |    2 +-
 drivers/acpi/acpica/evgpeutil.c |    2 +-
 drivers/acpi/acpica/evmisc.c    |    2 +-
 drivers/acpi/acpica/evregion.c  |    2 +-
 drivers/acpi/acpica/evrgnini.c  |    2 +-
 drivers/acpi/acpica/evsci.c     |    2 +-
 drivers/acpi/acpica/evxface.c   |    2 +-
 drivers/acpi/acpica/evxfevnt.c  |    2 +-
 drivers/acpi/acpica/evxfgpe.c   |    2 +-
 drivers/acpi/acpica/evxfregn.c  |    2 +-
 drivers/acpi/acpica/exconfig.c  |    2 +-
 drivers/acpi/acpica/exconvrt.c  |    2 +-
 drivers/acpi/acpica/excreate.c  |    2 +-
 drivers/acpi/acpica/exdebug.c   |    2 +-
 drivers/acpi/acpica/exdump.c    |    2 +-
 drivers/acpi/acpica/exfield.c   |    2 +-
 drivers/acpi/acpica/exfldio.c   |    2 +-
 drivers/acpi/acpica/exmisc.c    |    2 +-
 drivers/acpi/acpica/exmutex.c   |    2 +-
 drivers/acpi/acpica/exnames.c   |    2 +-
 drivers/acpi/acpica/exoparg1.c  |    2 +-
 drivers/acpi/acpica/exoparg2.c  |    2 +-
 drivers/acpi/acpica/exoparg3.c  |    2 +-
 drivers/acpi/acpica/exoparg6.c  |    2 +-
 drivers/acpi/acpica/exprep.c    |    2 +-
 drivers/acpi/acpica/exregion.c  |    2 +-
 drivers/acpi/acpica/exresnte.c  |    2 +-
 drivers/acpi/acpica/exresolv.c  |    2 +-
 drivers/acpi/acpica/exresop.c   |    2 +-
 drivers/acpi/acpica/exstore.c   |    2 +-
 drivers/acpi/acpica/exstoren.c  |    2 +-
 drivers/acpi/acpica/exstorob.c  |    2 +-
 drivers/acpi/acpica/exsystem.c  |    2 +-
 drivers/acpi/acpica/exutils.c   |    2 +-
 drivers/acpi/acpica/hwacpi.c    |    2 +-
 drivers/acpi/acpica/hwgpe.c     |    2 +-
 drivers/acpi/acpica/hwpci.c     |    2 +-
 drivers/acpi/acpica/hwregs.c    |    2 +-
 drivers/acpi/acpica/hwsleep.c   |    2 +-
 drivers/acpi/acpica/hwtimer.c   |    2 +-
 drivers/acpi/acpica/hwvalid.c   |    2 +-
 drivers/acpi/acpica/hwxface.c   |    2 +-
 drivers/acpi/acpica/nsaccess.c  |    2 +-
 drivers/acpi/acpica/nsalloc.c   |    2 +-
 drivers/acpi/acpica/nsdump.c    |    2 +-
 drivers/acpi/acpica/nsdumpdv.c  |    2 +-
 drivers/acpi/acpica/nseval.c    |    2 +-
 drivers/acpi/acpica/nsinit.c    |    2 +-
 drivers/acpi/acpica/nsload.c    |    2 +-
 drivers/acpi/acpica/nsnames.c   |    2 +-
 drivers/acpi/acpica/nsobject.c  |    2 +-
 drivers/acpi/acpica/nsparse.c   |    2 +-
 drivers/acpi/acpica/nspredef.c  |    2 +-
 drivers/acpi/acpica/nsrepair.c  |    2 +-
 drivers/acpi/acpica/nsrepair2.c |    2 +-
 drivers/acpi/acpica/nssearch.c  |    2 +-
 drivers/acpi/acpica/nsutils.c   |    2 +-
 drivers/acpi/acpica/nswalk.c    |    2 +-
 drivers/acpi/acpica/nsxfeval.c  |    2 +-
 drivers/acpi/acpica/nsxfname.c  |    2 +-
 drivers/acpi/acpica/nsxfobj.c   |    2 +-
 drivers/acpi/acpica/psargs.c    |    2 +-
 drivers/acpi/acpica/psloop.c    |    2 +-
 drivers/acpi/acpica/psopcode.c  |    2 +-
 drivers/acpi/acpica/psparse.c   |    2 +-
 drivers/acpi/acpica/psscope.c   |    2 +-
 drivers/acpi/acpica/pstree.c    |    2 +-
 drivers/acpi/acpica/psutils.c   |    2 +-
 drivers/acpi/acpica/pswalk.c    |    2 +-
 drivers/acpi/acpica/psxface.c   |    2 +-
 drivers/acpi/acpica/rsaddr.c    |    2 +-
 drivers/acpi/acpica/rscalc.c    |    2 +-
 drivers/acpi/acpica/rscreate.c  |    2 +-
 drivers/acpi/acpica/rsdump.c    |    2 +-
 drivers/acpi/acpica/rsinfo.c    |    2 +-
 drivers/acpi/acpica/rsio.c      |    2 +-
 drivers/acpi/acpica/rsirq.c     |    2 +-
 drivers/acpi/acpica/rslist.c    |    2 +-
 drivers/acpi/acpica/rsmemory.c  |    2 +-
 drivers/acpi/acpica/rsmisc.c    |    2 +-
 drivers/acpi/acpica/rsserial.c  |    2 +-
 drivers/acpi/acpica/rsutils.c   |    2 +-
 drivers/acpi/acpica/rsxface.c   |    2 +-
 drivers/acpi/acpica/tbfadt.c    |    2 +-
 drivers/acpi/acpica/tbfind.c    |    2 +-
 drivers/acpi/acpica/tbinstal.c  |    2 +-
 drivers/acpi/acpica/tbutils.c   |    2 +-
 drivers/acpi/acpica/tbxface.c   |    2 +-
 drivers/acpi/acpica/tbxfroot.c  |    2 +-
 drivers/acpi/acpica/utalloc.c   |    2 +-
 drivers/acpi/acpica/utcopy.c    |    2 +-
 drivers/acpi/acpica/utdebug.c   |    2 +-
 drivers/acpi/acpica/utdecode.c  |    2 +-
 drivers/acpi/acpica/utdelete.c  |    2 +-
 drivers/acpi/acpica/uteval.c    |    2 +-
 drivers/acpi/acpica/utglobal.c  |    2 +-
 drivers/acpi/acpica/utids.c     |    2 +-
 drivers/acpi/acpica/utinit.c    |    2 +-
 drivers/acpi/acpica/utlock.c    |    2 +-
 drivers/acpi/acpica/utmath.c    |    2 +-
 drivers/acpi/acpica/utmisc.c    |    2 +-
 drivers/acpi/acpica/utmutex.c   |    2 +-
 drivers/acpi/acpica/utobject.c  |    2 +-
 drivers/acpi/acpica/utosi.c     |    2 +-
 drivers/acpi/acpica/utresrc.c   |    2 +-
 drivers/acpi/acpica/utstate.c   |    2 +-
 drivers/acpi/acpica/utxface.c   |    2 +-
 drivers/acpi/acpica/utxferror.c |    2 +-
 drivers/acpi/acpica/utxfmutex.c |    2 +-
 148 files changed, 148 insertions(+), 148 deletions(-)

diff --git a/drivers/acpi/acpica/accommon.h b/drivers/acpi/acpica/accommon.h
index e0ba17f..a44bd42 100644
--- a/drivers/acpi/acpica/accommon.h
+++ b/drivers/acpi/acpica/accommon.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acconfig.h b/drivers/acpi/acpica/acconfig.h
index 4925aa5..1f30af6 100644
--- a/drivers/acpi/acpica/acconfig.h
+++ b/drivers/acpi/acpica/acconfig.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acdebug.h b/drivers/acpi/acpica/acdebug.h
index eb0b1f8..deaa819 100644
--- a/drivers/acpi/acpica/acdebug.h
+++ b/drivers/acpi/acpica/acdebug.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acdispat.h b/drivers/acpi/acpica/acdispat.h
index 2d1b7ff..5935ba6 100644
--- a/drivers/acpi/acpica/acdispat.h
+++ b/drivers/acpi/acpica/acdispat.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index f763b88..c53caa5 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index dd5a3e3..261fd5e 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/achware.h b/drivers/acpi/acpica/achware.h
index e7213be..677793e 100644
--- a/drivers/acpi/acpica/achware.h
+++ b/drivers/acpi/acpica/achware.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acinterp.h b/drivers/acpi/acpica/acinterp.h
index 4ee9058..eb30863 100644
--- a/drivers/acpi/acpica/acinterp.h
+++ b/drivers/acpi/acpica/acinterp.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index d3b6f29..3f24068 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acmacros.h b/drivers/acpi/acpica/acmacros.h
index b7491ee..ef338a9 100644
--- a/drivers/acpi/acpica/acmacros.h
+++ b/drivers/acpi/acpica/acmacros.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acnamesp.h b/drivers/acpi/acpica/acnamesp.h
index 79a598c..2c9e0f0 100644
--- a/drivers/acpi/acpica/acnamesp.h
+++ b/drivers/acpi/acpica/acnamesp.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 435dd2f..c065078 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acopcode.h b/drivers/acpi/acpica/acopcode.h
index 9896c77..9440d05 100644
--- a/drivers/acpi/acpica/acopcode.h
+++ b/drivers/acpi/acpica/acopcode.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acparser.h b/drivers/acpi/acpica/acparser.h
index 5ea1e06..b725d78 100644
--- a/drivers/acpi/acpica/acparser.h
+++ b/drivers/acpi/acpica/acparser.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acpredef.h b/drivers/acpi/acpica/acpredef.h
index ecac9cf..bbb34c9 100644
--- a/drivers/acpi/acpica/acpredef.h
+++ b/drivers/acpi/acpica/acpredef.h
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acresrc.h b/drivers/acpi/acpica/acresrc.h
index 61b2e04..0347d09 100644
--- a/drivers/acpi/acpica/acresrc.h
+++ b/drivers/acpi/acpica/acresrc.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acstruct.h b/drivers/acpi/acpica/acstruct.h
index 1623b24..0404df6 100644
--- a/drivers/acpi/acpica/acstruct.h
+++ b/drivers/acpi/acpica/acstruct.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/actables.h b/drivers/acpi/acpica/actables.h
index 967f081..d5bec30 100644
--- a/drivers/acpi/acpica/actables.h
+++ b/drivers/acpi/acpica/actables.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 57df293..925ccf2 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/amlcode.h b/drivers/acpi/acpica/amlcode.h
index c7db80e..905280f 100644
--- a/drivers/acpi/acpica/amlcode.h
+++ b/drivers/acpi/acpica/amlcode.h
@@ -7,7 +7,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/amlresrc.h b/drivers/acpi/acpica/amlresrc.h
index d4c3051..7b2128f 100644
--- a/drivers/acpi/acpica/amlresrc.h
+++ b/drivers/acpi/acpica/amlresrc.h
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsargs.c b/drivers/acpi/acpica/dsargs.c
index 19c2be9..80eb190 100644
--- a/drivers/acpi/acpica/dsargs.c
+++ b/drivers/acpi/acpica/dsargs.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dscontrol.c b/drivers/acpi/acpica/dscontrol.c
index 26c49ff..effe4ca 100644
--- a/drivers/acpi/acpica/dscontrol.c
+++ b/drivers/acpi/acpica/dscontrol.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsfield.c b/drivers/acpi/acpica/dsfield.c
index aa880d9..cd243cf 100644
--- a/drivers/acpi/acpica/dsfield.c
+++ b/drivers/acpi/acpica/dsfield.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsinit.c b/drivers/acpi/acpica/dsinit.c
index a7718bf..9e5ac7f 100644
--- a/drivers/acpi/acpica/dsinit.c
+++ b/drivers/acpi/acpica/dsinit.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index 5d79775..00f5dab 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsmthdat.c b/drivers/acpi/acpica/dsmthdat.c
index 905ce29..b40bd50 100644
--- a/drivers/acpi/acpica/dsmthdat.c
+++ b/drivers/acpi/acpica/dsmthdat.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsobject.c b/drivers/acpi/acpica/dsobject.c
index f42e17e..d7045ca 100644
--- a/drivers/acpi/acpica/dsobject.c
+++ b/drivers/acpi/acpica/dsobject.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsopcode.c b/drivers/acpi/acpica/dsopcode.c
index c627a28..e5eff75 100644
--- a/drivers/acpi/acpica/dsopcode.c
+++ b/drivers/acpi/acpica/dsopcode.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dsutils.c b/drivers/acpi/acpica/dsutils.c
index 2c477ce..1abcda3 100644
--- a/drivers/acpi/acpica/dsutils.c
+++ b/drivers/acpi/acpica/dsutils.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
index fe40e4c..642f3c0 100644
--- a/drivers/acpi/acpica/dswexec.c
+++ b/drivers/acpi/acpica/dswexec.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dswload.c b/drivers/acpi/acpica/dswload.c
index 324acec..552aa3a 100644
--- a/drivers/acpi/acpica/dswload.c
+++ b/drivers/acpi/acpica/dswload.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dswload2.c b/drivers/acpi/acpica/dswload2.c
index 9763181..ae71477 100644
--- a/drivers/acpi/acpica/dswload2.c
+++ b/drivers/acpi/acpica/dswload2.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dswscope.c b/drivers/acpi/acpica/dswscope.c
index 76a661f..9e9490a 100644
--- a/drivers/acpi/acpica/dswscope.c
+++ b/drivers/acpi/acpica/dswscope.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/dswstate.c b/drivers/acpi/acpica/dswstate.c
index a6c374e..c9c2ac1 100644
--- a/drivers/acpi/acpica/dswstate.c
+++ b/drivers/acpi/acpica/dswstate.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evevent.c b/drivers/acpi/acpica/evevent.c
index 1f43be4..6729ebe 100644
--- a/drivers/acpi/acpica/evevent.c
+++ b/drivers/acpi/acpica/evevent.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evglock.c b/drivers/acpi/acpica/evglock.c
index af1e71a..5e5683c 100644
--- a/drivers/acpi/acpica/evglock.c
+++ b/drivers/acpi/acpica/evglock.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 65c79ad..9e88cb6 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index ca2c41a..be75339 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evgpeinit.c b/drivers/acpi/acpica/evgpeinit.c
index ce9aa9f..adf7494 100644
--- a/drivers/acpi/acpica/evgpeinit.c
+++ b/drivers/acpi/acpica/evgpeinit.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeutil.c
index 80a81d0..2507393 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evmisc.c b/drivers/acpi/acpica/evmisc.c
index d0b3318..84966f4 100644
--- a/drivers/acpi/acpica/evmisc.c
+++ b/drivers/acpi/acpica/evmisc.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index dcdc7e4..1b0180a 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evrgnini.c b/drivers/acpi/acpica/evrgnini.c
index 55a5d35..819c17f 100644
--- a/drivers/acpi/acpica/evrgnini.c
+++ b/drivers/acpi/acpica/evrgnini.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evsci.c b/drivers/acpi/acpica/evsci.c
index 2ebd40e..26065c6 100644
--- a/drivers/acpi/acpica/evsci.c
+++ b/drivers/acpi/acpica/evsci.c
@@ -6,7 +6,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index f4f523b..61944e8 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evxfevnt.c b/drivers/acpi/acpica/evxfevnt.c
index 20516e5..1768bbe 100644
--- a/drivers/acpi/acpica/evxfevnt.c
+++ b/drivers/acpi/acpica/evxfevnt.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index f06a3ee..33388fd 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index aee887e..6019208c 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exconfig.c b/drivers/acpi/acpica/exconfig.c
index efe41f7..c86d44e 100644
--- a/drivers/acpi/acpica/exconfig.c
+++ b/drivers/acpi/acpica/exconfig.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exconvrt.c b/drivers/acpi/acpica/exconvrt.c
index 74162a1..e385436 100644
--- a/drivers/acpi/acpica/exconvrt.c
+++ b/drivers/acpi/acpica/exconvrt.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/excreate.c b/drivers/acpi/acpica/excreate.c
index c66562b..3f5bc99 100644
--- a/drivers/acpi/acpica/excreate.c
+++ b/drivers/acpi/acpica/excreate.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exdebug.c b/drivers/acpi/acpica/exdebug.c
index c7a2f1e..e211e9c 100644
--- a/drivers/acpi/acpica/exdebug.c
+++ b/drivers/acpi/acpica/exdebug.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exdump.c b/drivers/acpi/acpica/exdump.c
index c7064f4..2a6ac0a 100644
--- a/drivers/acpi/acpica/exdump.c
+++ b/drivers/acpi/acpica/exdump.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index 3aeec02..dc092f5 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exfldio.c b/drivers/acpi/acpica/exfldio.c
index 5b76c11..149de45 100644
--- a/drivers/acpi/acpica/exfldio.c
+++ b/drivers/acpi/acpica/exfldio.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exmisc.c b/drivers/acpi/acpica/exmisc.c
index 703d88e..0a08933 100644
--- a/drivers/acpi/acpica/exmisc.c
+++ b/drivers/acpi/acpica/exmisc.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exmutex.c b/drivers/acpi/acpica/exmutex.c
index be1c56e..60933e9 100644
--- a/drivers/acpi/acpica/exmutex.c
+++ b/drivers/acpi/acpica/exmutex.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exnames.c b/drivers/acpi/acpica/exnames.c
index 49ec049..fcc75fa 100644
--- a/drivers/acpi/acpica/exnames.c
+++ b/drivers/acpi/acpica/exnames.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exoparg1.c b/drivers/acpi/acpica/exoparg1.c
index 236ead1..9ba8c73 100644
--- a/drivers/acpi/acpica/exoparg1.c
+++ b/drivers/acpi/acpica/exoparg1.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exoparg2.c b/drivers/acpi/acpica/exoparg2.c
index 2571b4a..879e8a2 100644
--- a/drivers/acpi/acpica/exoparg2.c
+++ b/drivers/acpi/acpica/exoparg2.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exoparg3.c b/drivers/acpi/acpica/exoparg3.c
index 1b48d9d..71fcc65 100644
--- a/drivers/acpi/acpica/exoparg3.c
+++ b/drivers/acpi/acpica/exoparg3.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exoparg6.c b/drivers/acpi/acpica/exoparg6.c
index f4a2787..0786b86 100644
--- a/drivers/acpi/acpica/exoparg6.c
+++ b/drivers/acpi/acpica/exoparg6.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exprep.c b/drivers/acpi/acpica/exprep.c
index 18b75fe..30157f5 100644
--- a/drivers/acpi/acpica/exprep.c
+++ b/drivers/acpi/acpica/exprep.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exregion.c b/drivers/acpi/acpica/exregion.c
index f0d5e14..12d51df 100644
--- a/drivers/acpi/acpica/exregion.c
+++ b/drivers/acpi/acpica/exregion.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exresnte.c b/drivers/acpi/acpica/exresnte.c
index 55997e4..fa50e77 100644
--- a/drivers/acpi/acpica/exresnte.c
+++ b/drivers/acpi/acpica/exresnte.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exresolv.c b/drivers/acpi/acpica/exresolv.c
index db502cd..6e335dc 100644
--- a/drivers/acpi/acpica/exresolv.c
+++ b/drivers/acpi/acpica/exresolv.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exresop.c b/drivers/acpi/acpica/exresop.c
index e3bb00c..a67b1d9 100644
--- a/drivers/acpi/acpica/exresop.c
+++ b/drivers/acpi/acpica/exresop.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exstore.c b/drivers/acpi/acpica/exstore.c
index c0c8842..c6cf843 100644
--- a/drivers/acpi/acpica/exstore.c
+++ b/drivers/acpi/acpica/exstore.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exstoren.c b/drivers/acpi/acpica/exstoren.c
index a979017..b35bed5 100644
--- a/drivers/acpi/acpica/exstoren.c
+++ b/drivers/acpi/acpica/exstoren.c
@@ -7,7 +7,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exstorob.c b/drivers/acpi/acpica/exstorob.c
index dc665cc..65a45d8 100644
--- a/drivers/acpi/acpica/exstorob.c
+++ b/drivers/acpi/acpica/exstorob.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exsystem.c b/drivers/acpi/acpica/exsystem.c
index df66e7b..191a129 100644
--- a/drivers/acpi/acpica/exsystem.c
+++ b/drivers/acpi/acpica/exsystem.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/exutils.c b/drivers/acpi/acpica/exutils.c
index 3993aa5..eb6798b 100644
--- a/drivers/acpi/acpica/exutils.c
+++ b/drivers/acpi/acpica/exutils.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwacpi.c b/drivers/acpi/acpica/hwacpi.c
index fc380d3..d21ec5f 100644
--- a/drivers/acpi/acpica/hwacpi.c
+++ b/drivers/acpi/acpica/hwacpi.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwgpe.c b/drivers/acpi/acpica/hwgpe.c
index f610d88..1a6894a 100644
--- a/drivers/acpi/acpica/hwgpe.c
+++ b/drivers/acpi/acpica/hwgpe.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwpci.c b/drivers/acpi/acpica/hwpci.c
index 050fd22..1455ddc 100644
--- a/drivers/acpi/acpica/hwpci.c
+++ b/drivers/acpi/acpica/hwpci.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index cc70f3f..4ea4eeb5 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -7,7 +7,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index d52da30..3c4a922 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwtimer.c b/drivers/acpi/acpica/hwtimer.c
index 50d21c4..d4973d9 100644
--- a/drivers/acpi/acpica/hwtimer.c
+++ b/drivers/acpi/acpica/hwtimer.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
index f8fbea9..6e5c43a 100644
--- a/drivers/acpi/acpica/hwvalid.c
+++ b/drivers/acpi/acpica/hwvalid.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index c2793a8..7bdbbcf 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsaccess.c b/drivers/acpi/acpica/nsaccess.c
index d93172f..61623f3 100644
--- a/drivers/acpi/acpica/nsaccess.c
+++ b/drivers/acpi/acpica/nsaccess.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsalloc.c b/drivers/acpi/acpica/nsalloc.c
index 1d0ef15..7c3d3ce 100644
--- a/drivers/acpi/acpica/nsalloc.c
+++ b/drivers/acpi/acpica/nsalloc.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsdump.c b/drivers/acpi/acpica/nsdump.c
index b683cc2..b7f2b3b 100644
--- a/drivers/acpi/acpica/nsdump.c
+++ b/drivers/acpi/acpica/nsdump.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsdumpdv.c b/drivers/acpi/acpica/nsdumpdv.c
index 2ed294b..30ea5bc 100644
--- a/drivers/acpi/acpica/nsdumpdv.c
+++ b/drivers/acpi/acpica/nsdumpdv.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nseval.c b/drivers/acpi/acpica/nseval.c
index c1bd02b..f375cb8 100644
--- a/drivers/acpi/acpica/nseval.c
+++ b/drivers/acpi/acpica/nseval.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsinit.c b/drivers/acpi/acpica/nsinit.c
index fd7c638..9d84ec2 100644
--- a/drivers/acpi/acpica/nsinit.c
+++ b/drivers/acpi/acpica/nsinit.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsload.c b/drivers/acpi/acpica/nsload.c
index 5f7dc69..5cbf15f 100644
--- a/drivers/acpi/acpica/nsload.c
+++ b/drivers/acpi/acpica/nsload.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsnames.c b/drivers/acpi/acpica/nsnames.c
index d5fa520..b20e7c8 100644
--- a/drivers/acpi/acpica/nsnames.c
+++ b/drivers/acpi/acpica/nsnames.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsobject.c b/drivers/acpi/acpica/nsobject.c
index 3bb8bf1..dd77a3c 100644
--- a/drivers/acpi/acpica/nsobject.c
+++ b/drivers/acpi/acpica/nsobject.c
@@ -6,7 +6,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsparse.c b/drivers/acpi/acpica/nsparse.c
index b3234fa..ec7ba2d 100644
--- a/drivers/acpi/acpica/nsparse.c
+++ b/drivers/acpi/acpica/nsparse.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nspredef.c b/drivers/acpi/acpica/nspredef.c
index db80366..bbe46a4 100644
--- a/drivers/acpi/acpica/nspredef.c
+++ b/drivers/acpi/acpica/nspredef.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index dd0a0bd..9c35d20 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 3ee2b22..726bc8e 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nssearch.c b/drivers/acpi/acpica/nssearch.c
index 28b0d7a..507043d 100644
--- a/drivers/acpi/acpica/nssearch.c
+++ b/drivers/acpi/acpica/nssearch.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsutils.c b/drivers/acpi/acpica/nsutils.c
index cb1b104..a535b7a 100644
--- a/drivers/acpi/acpica/nsutils.c
+++ b/drivers/acpi/acpica/nsutils.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nswalk.c b/drivers/acpi/acpica/nswalk.c
index 345f0c3..f69895a 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsxfeval.c b/drivers/acpi/acpica/nsxfeval.c
index e7f016d..71d15f6 100644
--- a/drivers/acpi/acpica/nsxfeval.c
+++ b/drivers/acpi/acpica/nsxfeval.c
@@ -6,7 +6,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
index 83bf930..af401c9 100644
--- a/drivers/acpi/acpica/nsxfname.c
+++ b/drivers/acpi/acpica/nsxfname.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/nsxfobj.c b/drivers/acpi/acpica/nsxfobj.c
index 57e6d82..880a605 100644
--- a/drivers/acpi/acpica/nsxfobj.c
+++ b/drivers/acpi/acpica/nsxfobj.c
@@ -6,7 +6,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 4037f90..5ac36ab 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psloop.c b/drivers/acpi/acpica/psloop.c
index 01dd70d..9547ad8 100644
--- a/drivers/acpi/acpica/psloop.c
+++ b/drivers/acpi/acpica/psloop.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psopcode.c b/drivers/acpi/acpica/psopcode.c
index 9b31910..a0226fd 100644
--- a/drivers/acpi/acpica/psopcode.c
+++ b/drivers/acpi/acpica/psopcode.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psparse.c b/drivers/acpi/acpica/psparse.c
index 9bb0cbd..2ff9c35 100644
--- a/drivers/acpi/acpica/psparse.c
+++ b/drivers/acpi/acpica/psparse.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psscope.c b/drivers/acpi/acpica/psscope.c
index a5faa13..c872aa4 100644
--- a/drivers/acpi/acpica/psscope.c
+++ b/drivers/acpi/acpica/psscope.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/pstree.c b/drivers/acpi/acpica/pstree.c
index 04311bb..2b03cdb 100644
--- a/drivers/acpi/acpica/pstree.c
+++ b/drivers/acpi/acpica/pstree.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psutils.c b/drivers/acpi/acpica/psutils.c
index 7eda785..13bb131 100644
--- a/drivers/acpi/acpica/psutils.c
+++ b/drivers/acpi/acpica/psutils.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/pswalk.c b/drivers/acpi/acpica/pswalk.c
index 3312d63..ab96cf4 100644
--- a/drivers/acpi/acpica/pswalk.c
+++ b/drivers/acpi/acpica/pswalk.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/psxface.c b/drivers/acpi/acpica/psxface.c
index 8086805..9d98c5f 100644
--- a/drivers/acpi/acpica/psxface.c
+++ b/drivers/acpi/acpica/psxface.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsaddr.c b/drivers/acpi/acpica/rsaddr.c
index 9e66f90..a030565 100644
--- a/drivers/acpi/acpica/rsaddr.c
+++ b/drivers/acpi/acpica/rsaddr.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rscalc.c b/drivers/acpi/acpica/rscalc.c
index 3a29b4dd..3c6df4b 100644
--- a/drivers/acpi/acpica/rscalc.c
+++ b/drivers/acpi/acpica/rscalc.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rscreate.c b/drivers/acpi/acpica/rscreate.c
index 06264e8..46d6eb3 100644
--- a/drivers/acpi/acpica/rscreate.c
+++ b/drivers/acpi/acpica/rscreate.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsdump.c b/drivers/acpi/acpica/rsdump.c
index 9969985..b4c5811 100644
--- a/drivers/acpi/acpica/rsdump.c
+++ b/drivers/acpi/acpica/rsdump.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsinfo.c b/drivers/acpi/acpica/rsinfo.c
index e5489bf..a9fa515 100644
--- a/drivers/acpi/acpica/rsinfo.c
+++ b/drivers/acpi/acpica/rsinfo.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsio.c b/drivers/acpi/acpica/rsio.c
index 0c7efef..f6a0810 100644
--- a/drivers/acpi/acpica/rsio.c
+++ b/drivers/acpi/acpica/rsio.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsirq.c b/drivers/acpi/acpica/rsirq.c
index 3ac9d4a..e23a9ec 100644
--- a/drivers/acpi/acpica/rsirq.c
+++ b/drivers/acpi/acpica/rsirq.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rslist.c b/drivers/acpi/acpica/rslist.c
index c446351..9be129f 100644
--- a/drivers/acpi/acpica/rslist.c
+++ b/drivers/acpi/acpica/rslist.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsmemory.c b/drivers/acpi/acpica/rsmemory.c
index 7cc6d86..4fd611a 100644
--- a/drivers/acpi/acpica/rsmemory.c
+++ b/drivers/acpi/acpica/rsmemory.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsmisc.c b/drivers/acpi/acpica/rsmisc.c
index af3dc63..8073b37 100644
--- a/drivers/acpi/acpica/rsmisc.c
+++ b/drivers/acpi/acpica/rsmisc.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsserial.c b/drivers/acpi/acpica/rsserial.c
index d0b8e12..9aa5e68 100644
--- a/drivers/acpi/acpica/rsserial.c
+++ b/drivers/acpi/acpica/rsserial.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsutils.c b/drivers/acpi/acpica/rsutils.c
index 54a9a97..433a375 100644
--- a/drivers/acpi/acpica/rsutils.c
+++ b/drivers/acpi/acpica/rsutils.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/rsxface.c b/drivers/acpi/acpica/rsxface.c
index f6cceac..f58c098 100644
--- a/drivers/acpi/acpica/rsxface.c
+++ b/drivers/acpi/acpica/rsxface.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index ff1f7f0..c5d8704 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbfind.c b/drivers/acpi/acpica/tbfind.c
index a55cb2b..4903e36 100644
--- a/drivers/acpi/acpica/tbfind.c
+++ b/drivers/acpi/acpica/tbfind.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbinstal.c b/drivers/acpi/acpica/tbinstal.c
index 62365f6..1aecf7b 100644
--- a/drivers/acpi/acpica/tbinstal.c
+++ b/drivers/acpi/acpica/tbinstal.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbutils.c b/drivers/acpi/acpica/tbutils.c
index da56a19..09ca39e 100644
--- a/drivers/acpi/acpica/tbutils.c
+++ b/drivers/acpi/acpica/tbutils.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index e7d13f5..abcc641 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -6,7 +6,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/tbxfroot.c b/drivers/acpi/acpica/tbxfroot.c
index 7eb6c6c..4258f64 100644
--- a/drivers/acpi/acpica/tbxfroot.c
+++ b/drivers/acpi/acpica/tbxfroot.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utalloc.c b/drivers/acpi/acpica/utalloc.c
index 0a69735..9982d2ea 100644
--- a/drivers/acpi/acpica/utalloc.c
+++ b/drivers/acpi/acpica/utalloc.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index aded299..3317c0a 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utdebug.c b/drivers/acpi/acpica/utdebug.c
index a1f8d75..a0998a8 100644
--- a/drivers/acpi/acpica/utdebug.c
+++ b/drivers/acpi/acpica/utdebug.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index 6fd56d5..d42ede52 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utdelete.c b/drivers/acpi/acpica/utdelete.c
index 93ec06b..2a6c3e1 100644
--- a/drivers/acpi/acpica/utdelete.c
+++ b/drivers/acpi/acpica/utdelete.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/uteval.c b/drivers/acpi/acpica/uteval.c
index 18f73c9..479f32b 100644
--- a/drivers/acpi/acpica/uteval.c
+++ b/drivers/acpi/acpica/uteval.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
index 3cf758b..4153584 100644
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utids.c b/drivers/acpi/acpica/utids.c
index b679ea6..c92eb1d 100644
--- a/drivers/acpi/acpica/utids.c
+++ b/drivers/acpi/acpica/utids.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utinit.c b/drivers/acpi/acpica/utinit.c
index cab61a0..8359c0c 100644
--- a/drivers/acpi/acpica/utinit.c
+++ b/drivers/acpi/acpica/utinit.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utlock.c b/drivers/acpi/acpica/utlock.c
index f6bb75c..155fd78 100644
--- a/drivers/acpi/acpica/utlock.c
+++ b/drivers/acpi/acpica/utlock.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utmath.c b/drivers/acpi/acpica/utmath.c
index ce481da..2491a55 100644
--- a/drivers/acpi/acpica/utmath.c
+++ b/drivers/acpi/acpica/utmath.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
index c33a852..86f19db 100644
--- a/drivers/acpi/acpica/utmisc.c
+++ b/drivers/acpi/acpica/utmisc.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 302c74e..43174df 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utobject.c b/drivers/acpi/acpica/utobject.c
index 188340a..b112744 100644
--- a/drivers/acpi/acpica/utobject.c
+++ b/drivers/acpi/acpica/utobject.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utosi.c b/drivers/acpi/acpica/utosi.c
index 1fb10cb..2360cf7 100644
--- a/drivers/acpi/acpica/utosi.c
+++ b/drivers/acpi/acpica/utosi.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utresrc.c b/drivers/acpi/acpica/utresrc.c
index cd7fbbf..9d441ea 100644
--- a/drivers/acpi/acpica/utresrc.c
+++ b/drivers/acpi/acpica/utresrc.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utstate.c b/drivers/acpi/acpica/utstate.c
index 30c21e1..4267477 100644
--- a/drivers/acpi/acpica/utstate.c
+++ b/drivers/acpi/acpica/utstate.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
index 15cbdde..644e8c8 100644
--- a/drivers/acpi/acpica/utxface.c
+++ b/drivers/acpi/acpica/utxface.c
@@ -5,7 +5,7 @@
  *****************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utxferror.c b/drivers/acpi/acpica/utxferror.c
index 8d0245e..52b568a 100644
--- a/drivers/acpi/acpica/utxferror.c
+++ b/drivers/acpi/acpica/utxferror.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
diff --git a/drivers/acpi/acpica/utxfmutex.c b/drivers/acpi/acpica/utxfmutex.c
index 1ea016b..1427d19 100644
--- a/drivers/acpi/acpica/utxfmutex.c
+++ b/drivers/acpi/acpica/utxfmutex.c
@@ -5,7 +5,7 @@
  ******************************************************************************/
 
 /*
- * Copyright (C) 2000 - 2011, Intel Corp.
+ * Copyright (C) 2000 - 2012, Intel Corp.
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
-- 
1.7.9.rc1


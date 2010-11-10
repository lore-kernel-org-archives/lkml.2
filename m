Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0KJWna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:43:30 -0500
Received: from xenotime.net ([72.52.115.56]:52660 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757312Ab0KJWnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:43:25 -0500
Date: Wed, 10 Nov 2010 11:53:50 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: [PATCH 4/8] Documentation: change email address for Hans Koch
Message-ID: <12894188301528@xenotime.net>
In-Reply-To: <1289418830794@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans J. Koch <hjk@hansjkoch.de>

My old mail address doesn't exist anymore. This changes all occurrences
to my new address.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/uio-howto.tmpl |    6 +++---
 Documentation/hwmon/lm93             |    2 +-
 Documentation/hwmon/max6650          |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.37-rc1-git8.orig/Documentation/DocBook/uio-howto.tmpl
+++ linux-2.6.37-rc1-git8/Documentation/DocBook/uio-howto.tmpl
@@ -16,7 +16,7 @@
 	</orgname>
 
 	<address>
-	   <email>hjk@linutronix.de</email>
+	   <email>hjk@hansjkoch.de</email>
 	</address>
     </affiliation>
 </author>
@@ -114,7 +114,7 @@ GPL version 2.
 
 <para>If you know of any translations for this document, or you are
 interested in translating it, please email me
-<email>hjk@linutronix.de</email>.
+<email>hjk@hansjkoch.de</email>.
 </para>
 </sect1>
 
@@ -171,7 +171,7 @@ interested in translating it, please ema
 <title>Feedback</title>
 	<para>Find something wrong with this document? (Or perhaps something
 	right?) I would love to hear from you. Please email me at
-	<email>hjk@linutronix.de</email>.</para>
+	<email>hjk@hansjkoch.de</email>.</para>
 </sect1>
 </chapter>
 
--- linux-2.6.37-rc1-git8.orig/Documentation/hwmon/lm93
+++ linux-2.6.37-rc1-git8/Documentation/hwmon/lm93
@@ -11,7 +11,7 @@ Authors:
 	Mark M. Hoffman <mhoffman@lightlink.com>
 	Ported to 2.6 by Eric J. Bowersox <ericb@aspsys.com>
 	Adapted to 2.6.20 by Carsten Emde <ce@osadl.org>
-	Modified for mainline integration by Hans J. Koch <hjk@linutronix.de>
+	Modified for mainline integration by Hans J. Koch <hjk@hansjkoch.de>
 
 Module Parameters
 -----------------
--- linux-2.6.37-rc1-git8.orig/Documentation/hwmon/max6650
+++ linux-2.6.37-rc1-git8/Documentation/hwmon/max6650
@@ -8,7 +8,7 @@ Supported chips:
     Datasheet: http://pdfserv.maxim-ic.com/en/ds/MAX6650-MAX6651.pdf
 
 Authors:
-    Hans J. Koch <hjk@linutronix.de>
+    Hans J. Koch <hjk@hansjkoch.de>
     John Morris <john.morris@spirentcom.com>
     Claus Gindhart <claus.gindhart@kontron.com>
 


-- 


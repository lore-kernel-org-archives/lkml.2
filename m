Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab0J2WYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:24:52 -0400
Received: from static.200.77.63.178.clients.your-server.de ([178.63.77.200]:48520
	"EHLO Debian-50-lenny-64-minimal" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932472Ab0J2WYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:24:51 -0400
X-Greylist: delayed 740 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2010 18:24:51 EDT
Date: Sat, 30 Oct 2010 00:24:51 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-doc@vger.kernel.org
Subject: [PATCH 1/6] Documentation: Change mail address of Hans J. Koch
Message-ID: <20101029222451.GB4331@local>
References: <20101029221231.GA4331@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029221231.GA4331@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My old mail address doesn't exist anymore. This changes all occurrences
to my new address.

Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
---
 Documentation/DocBook/uio-howto.tmpl |    6 +++---
 Documentation/hwmon/lm93             |    2 +-
 Documentation/hwmon/max6650          |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 4d4ce0e..b4665b9 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
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
 
@@ -171,7 +171,7 @@ interested in translating it, please email me
 <title>Feedback</title>
 	<para>Find something wrong with this document? (Or perhaps something
 	right?) I would love to hear from you. Please email me at
-	<email>hjk@linutronix.de</email>.</para>
+	<email>hjk@hansjkoch.de</email>.</para>
 </sect1>
 </chapter>
 
diff --git a/Documentation/hwmon/lm93 b/Documentation/hwmon/lm93
index ac711f3..7a10616 100644
--- a/Documentation/hwmon/lm93
+++ b/Documentation/hwmon/lm93
@@ -11,7 +11,7 @@ Authors:
 	Mark M. Hoffman <mhoffman@lightlink.com>
 	Ported to 2.6 by Eric J. Bowersox <ericb@aspsys.com>
 	Adapted to 2.6.20 by Carsten Emde <ce@osadl.org>
-	Modified for mainline integration by Hans J. Koch <hjk@linutronix.de>
+	Modified for mainline integration by Hans J. Koch <hjk@hansjkoch.de>
 
 Module Parameters
 -----------------
diff --git a/Documentation/hwmon/max6650 b/Documentation/hwmon/max6650
index 8be7beb..c565650 100644
--- a/Documentation/hwmon/max6650
+++ b/Documentation/hwmon/max6650
@@ -8,7 +8,7 @@ Supported chips:
     Datasheet: http://pdfserv.maxim-ic.com/en/ds/MAX6650-MAX6651.pdf
 
 Authors:
-    Hans J. Koch <hjk@linutronix.de>
+    Hans J. Koch <hjk@hansjkoch.de>
     John Morris <john.morris@spirentcom.com>
     Claus Gindhart <claus.gindhart@kontron.com>
 
-- 
1.7.1


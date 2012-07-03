Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2GCJ1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:27:30 -0400
Received: from skyrme.org ([193.175.80.135]:44117 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab2GCJ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:27:29 -0400
Date: 3 Jul 2012 09:27:24 +0000
Message-Id: <1341307645-15135-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Rob Landley" <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
        "Oskar Schirmer" <oskar@scara.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David Brownell" <david-b@pacbell.net>,
        "Alan Stern" <stern@rowland.harvard.edu>
Subject: [PATCH 1/2] Documentation: fix typos in power management description
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just two missing characters.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 Documentation/power/devices.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/power/devices.txt b/Documentation/power/devices.txt
index 872815c..504dfe4 100644
--- a/Documentation/power/devices.txt
+++ b/Documentation/power/devices.txt
@@ -583,9 +583,10 @@ for the given device during all power transitions, instead of the respective
 subsystem-level callbacks.  Specifically, if a device's pm_domain pointer is
 not NULL, the ->suspend() callback from the object pointed to by it will be
 executed instead of its subsystem's (e.g. bus type's) ->suspend() callback and
-anlogously for all of the remaining callbacks.  In other words, power management
-domain callbacks, if defined for the given device, always take precedence over
-the callbacks provided by the device's subsystem (e.g. bus type).
+analogously for all of the remaining callbacks.  In other words, power
+management domain callbacks, if defined for the given device, always take
+precedence over the callbacks provided by the device's subsystem (e.g. bus
+type).
 
 The support for device power management domains is only relevant to platforms
 needing to use the same device driver power management callbacks in many
@@ -598,7 +599,7 @@ it into account in any way.
 Device Low Power (suspend) States
 ---------------------------------
 Device low-power states aren't standard.  One device might only handle
-"on" and "off, while another might support a dozen different versions of
+"on" and "off", while another might support a dozen different versions of
 "on" (how many engines are active?), plus a state that gets back to "on"
 faster than from a full "off".
 
-- 
1.7.9.5


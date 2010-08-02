Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0HBHnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:43:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52374 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109Ab0HBHnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:43:31 -0400
From: pavan_savoy@ti.com
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, pavan_savoy@sify.com,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:staging:ti-st: update TODO
Date: Mon,  2 Aug 2010 02:43:17 -0500
Message-Id: <1280734997-602-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Removed TODO item 2 :
Current UIM/KIM communicate via the rfkill device and identified by the unique idx
assisgned by the rfkill sub-system to each of these rfkill entries.

Removed TODO item 1 :
Since there is no way we can test existance of multiple connectivity
devices on  platform.
However the basic infrastructure as in providing a context to ST driver
exist.
If multiple devices have to exist on a given platform, multiple ST
platform devices need to be registered and each of the protocol drivers
have to mention which platform device they want to bind to/make use of.

Removed TODO item 3:
Locking have been reviewed and commit
36b5aee46b5e4788758409829926c631de0a64a3 documents locking.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/staging/ti-st/TODO |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
index 6a105ed..ebfd6bb 100644
--- a/drivers/staging/ti-st/TODO
+++ b/drivers/staging/ti-st/TODO
@@ -1,22 +1,6 @@
 TODO:
 
-1. A per-device/tty port context required to support multiple devices
-on same platform.
-Plan: Each BT, FM and GPS device would be a platform-device with its platform-data
-mentioning which of the ST device it wants to attach itself onto.
-
-There by each of the ST device which is also a platform device upon receiving
-a st_register() would know whether the registration from BT/FM or GPS was intended for it.
-
-2. Improve upon the way requirement of line discipline is communicated to
-user-space, The current user-space application which open/installs ldisc
-as and when required can be found at,
-http://dev.omapzoom.org/pub/scm/jsistla/L23-btfm.git
-branch: UIM
-
-3. Re-view/Re-work on the locking.
-
-4. Step up and maintain this driver to ensure that it continues
+1. Step up and maintain this driver to ensure that it continues
 to work.  Having the hardware for this is pretty much a
 requirement.  If this does not happen, the will be removed in
 the 2.6.35 kernel release.
-- 
1.5.6.3


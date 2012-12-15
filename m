Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab2LOGD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 01:03:57 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:48839 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588Ab2LOGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 01:03:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 6/6] staging/fwserial: Drop suggestion for helper fn integration
Date: Sat, 15 Dec 2012 01:03:20 -0500
Message-Id: <1355551400-8204-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewire core does not require or want the suggested helper fns;
drop suggestion from TODO file.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
index 8dae8fb..dc61d97 100644
--- a/drivers/staging/fwserial/TODO
+++ b/drivers/staging/fwserial/TODO
@@ -12,8 +12,6 @@ TODOs prior to this driver moving out of staging
 1. This driver uses the same unregistered vendor id that the firewire core does
      (0xd00d1e). Perhaps this could be exposed as a define in
      firewire.h?
-3. Maybe device_max_receive() and link_speed_to_max_payload() should be
-     taken up by the firewire core?
 
 -- Issues with TTY core --
   1. Hack for alternate device name scheme
-- 
1.8.0.1


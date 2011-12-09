Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab1LIIN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:13:59 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:45636 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752315Ab1LIIN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:13:57 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 6/8] MAINTAINERS: brcm80211: Update F: pattern
Date: Fri,  9 Dec 2011 00:12:52 -0800
Message-Id: <4dac2c8b01628a8875dfd2f9b87fa3135bb46e62.1323418149.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1323418149.git.joe@perches.com>
References: <cover.1323418149.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fc2d6e573be
("staging: brcm80211: remove brcm80211 driver from the staging tree")
moved the files, update the F: pattern.

CC: John W. Linville <linville@tuxdriver.com>
CC: Arend van Spriel <arend@broadcom.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b40e522..dd083d2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1590,7 +1590,7 @@ M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
 M:	Kan Yan	<kanyan@broadcom.com>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
-F:	drivers/staging/brcm80211/
+F:	drivers/net/wireless/brcm80211/
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
 M:	Bhanu Prakash Gollapudi <bprakash@broadcom.com>
-- 
1.7.8.111.gad25c.dirty


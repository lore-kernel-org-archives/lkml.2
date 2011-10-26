Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1JZVQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:16:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36821 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1JZVPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:15:08 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        Andrew Skalski <askalski@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Input: psmouse - Add PSMOUSE_CMD_RESET_WRAP
Date: Wed, 26 Oct 2011 16:14:36 -0500
Message-Id: <1319663681-11244-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com>
References: <1319663681-11244-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this command in preparation for new ALPS protocol support.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/input/mouse/psmouse.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 593e910..c2b5aa6 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -8,6 +8,7 @@
 #define PSMOUSE_CMD_SETSTREAM	0x00ea
 #define PSMOUSE_CMD_SETPOLL	0x00f0
 #define PSMOUSE_CMD_POLL	0x00eb	/* caller sets number of bytes to receive */
+#define PSMOUSE_CMD_RESET_WRAP	0x00ec
 #define PSMOUSE_CMD_GETID	0x02f2
 #define PSMOUSE_CMD_SETRATE	0x10f3
 #define PSMOUSE_CMD_ENABLE	0x00f4
-- 
1.7.5.4


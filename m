Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1AWAHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 19:07:32 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:38999
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751002Ab1AWAHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 19:07:31 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        trivial@kernel.org,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [trivial][PATCH v2 1/3] Staging: rt2860: rt_linux.c: Fix space after unary '*' operator.
Date: Sun, 23 Jan 2011 01:07:18 +0100
Message-Id: <1295741240-11254-2-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.4.rc0.5.gf2665
In-Reply-To: <1295741240-11254-1-git-send-email-agimenez@sysvalve.es>
References: <20110121201417.GA22299@kroah.com>
 <1295741240-11254-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch error raised by the use of spaces between the '*' operator and
the corresponding variable name.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/rt_linux.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 728864e..b3f836d 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -118,8 +118,7 @@ void RTMP_OS_Mod_Timer(struct timer_list *pTimer,
 	mod_timer(pTimer, jiffies + timeout);
 }
 
-void RTMP_OS_Del_Timer(struct timer_list *pTimer,
-		       OUT BOOLEAN * pCancelled)
+void RTMP_OS_Del_Timer(struct timer_list *pTimer, OUT BOOLEAN *pCancelled)
 {
 	if (timer_pending(pTimer)) {
 		*pCancelled = del_timer_sync(pTimer);
-- 
1.7.4.rc0.5.gf2665


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1H2V1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:27:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49276 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754317Ab1H2V1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:27:39 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX19ttW84iaJttQo8bujp17DFaHgLGmvo/ANyWVNDyF
	7b9Rd5T6o1aJVt
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH trivial] input: apanel: remove a redundant MODULE_ALIAS
Date: Mon, 29 Aug 2011 23:26:29 +0200
Message-Id: <1314653189-31020-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 drivers/input/misc/apanel.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/apanel.c b/drivers/input/misc/apanel.c
index a8d2b8d..1dd1bd3 100644
--- a/drivers/input/misc/apanel.c
+++ b/drivers/input/misc/apanel.c
@@ -346,5 +346,4 @@ MODULE_DESCRIPTION(APANEL_NAME " driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(APANEL_VERSION);
 
-MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
 MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
-- 
1.7.5.4


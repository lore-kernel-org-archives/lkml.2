Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab1GGHls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:41:48 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:42538 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab1GGHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:41:46 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] staging: usbip: userspace: usbip: modify `list' help message
Date: Thu,  7 Jul 2011 00:31:54 -0700
Message-Id: <4562e25c5cd1ef1e6e46f6122756477b41fb420c.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310023068.git.mfm@muteddisk.com>
References: <cover.1310023068.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remote devices listed are, technically, exportable and not
necessarily exported.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip.c      |    2 +-
 drivers/staging/usbip/userspace/src/usbip_list.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 583b179..fff4b76 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -77,7 +77,7 @@ static const struct command cmds[] = {
 	{
 		.name  = "list",
 		.fn    = usbip_list,
-		.help  = "List exported or local USB devices",
+		.help  = "List exportable or local USB devices",
 		.usage = usbip_list_usage
 	},
 	{
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 6349638..ed30d91 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -37,7 +37,7 @@
 static const char usbip_list_usage_string[] =
 	"usbip list [-p|--parsable] <args>\n"
 	"    -p, --parsable         Parsable list format\n"
-	"    -r, --remote=<host>    List the exported USB devices on <host>\n"
+	"    -r, --remote=<host>    List the exportable USB devices on <host>\n"
 	"    -l, --local            List the local USB devices\n";
 
 void usbip_list_usage(void)
-- 
1.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab2ETLmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 07:42:32 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:52755
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1751843Ab2ETLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 07:42:31 -0400
Date: Sun, 20 May 2012 13:42:29 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [patch] UBI: add in hex the value for UBI_INTERNAL_VOL_START to
 comment
Message-ID: <alpine.DEB.2.00.1205201340410.26953@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly provide the first internal volume ID value in the comment for
UBI_INTERNAL_VOL_START. This allows developers who, when adding features
related to volume ids and observe unexpected very large volume ids, to grep
for the observed value in the source code and find out immediately that it is
expected behaviour.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 drivers/mtd/ubi/ubi-media.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 6fb8ec2..9dab25d 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -298,8 +298,8 @@ struct ubi_vid_hdr {
 #define UBI_INT_VOL_COUNT 1

 /*
- * Starting ID of internal volumes. There is reserved room for 4096 internal
- * volumes.
+ * Starting ID of internal volumes: 0x7fffefff.
+ * There is reserved room for 4096 internal volumes.
  */
 #define UBI_INTERNAL_VOL_START (0x7FFFFFFF - 4096)

-- 
1.7.5.4


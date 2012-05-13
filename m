Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2EMPhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:37:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62814 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2EMPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:37:10 -0400
From: joseph daniel <josephdanielwalter@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Piotr Chmura <chmooreck@poczta.onet.pl>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] staging/media/as102: remove version.h include at as102_fe.c
Date: Sun, 13 May 2012 21:06:57 +0530
Message-Id: <1336923417-7359-1-git-send-email-josephdanielwalter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a warning when ran "make versioncheck"

drivers/staging/media/as102/as102_fe.c: 20 linux/version.h not needed.

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/staging/media/as102/as102_fe.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/media/as102/as102_fe.c b/drivers/staging/media/as102/as102_fe.c
index 5917657..9ce8c9d 100644
--- a/drivers/staging/media/as102/as102_fe.c
+++ b/drivers/staging/media/as102/as102_fe.c
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-#include <linux/version.h>
-
 #include "as102_drv.h"
 #include "as10x_types.h"
 #include "as10x_cmd.h"
-- 
1.7.9.5


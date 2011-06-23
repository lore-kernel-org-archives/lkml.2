Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964859Ab1FWXCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:02:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:48632 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933959Ab1FWXCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:02:24 -0400
Date: Fri, 24 Jun 2011 00:53:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Jarod Wilson <jarod@redhat.com>, devel@driverdev.osuosl.org,
        Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 27/37] Remove unneeded version.h includes from
 drivers/staging/lirc/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240052170.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/lirc/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/lirc/lirc_ttusbir.c |    1 -
 drivers/staging/lirc/lirc_zilog.c   |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lirc/lirc_ttusbir.c b/drivers/staging/lirc/lirc_ttusbir.c
index e345ab9..e4b329b 100644
--- a/drivers/staging/lirc/lirc_ttusbir.c
+++ b/drivers/staging/lirc/lirc_ttusbir.c
@@ -30,7 +30,6 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index dd6a57c..a8efe41 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -39,8 +39,6 @@
  *
  */
 
-
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/kernel.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab1F1Qeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:34:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1F1Qby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:31:54 -0400
Date: Mon, 27 Jun 2011 23:17:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 02/13] [media] drxd, siano: Remove unused include
 linux/version.h
Message-ID: <20110627231725.2a68c0a6@pedra>
In-Reply-To: <cover.1309226359.git.mchehab@redhat.com>
References: <cover.1309226359.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both drxd and siano drivers were including linux/version.h without
any reason. Probably, this is due to some compatibility code that
used to exist before having their support added into the Linux
Kernel.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index ea4c1c3..f132e49 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -28,7 +28,6 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
-#include <linux/version.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/siano/smscoreapi.h b/drivers/media/dvb/siano/smscoreapi.h
index 8ecadec..c592ae0 100644
--- a/drivers/media/dvb/siano/smscoreapi.h
+++ b/drivers/media/dvb/siano/smscoreapi.h
@@ -22,7 +22,6 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #ifndef __SMS_CORE_API_H__
 #define __SMS_CORE_API_H__
 
-#include <linux/version.h>
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/mm.h>
-- 
1.7.1



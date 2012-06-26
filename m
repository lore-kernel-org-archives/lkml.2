Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2FZRHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:07:41 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:11537 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786Ab2FZRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:07:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1340730439!6375310!24
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: comedi: cb_das16_cs: reword the comment about PCMCIA support
Date: Tue, 26 Jun 2012 10:07:23 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206261007.24483.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original comment about the PCMCIA support code was wrong in that
it said this driver was for the "pcm-das08". When it was moved the
comment was reworded badly.

Fix the comment so it makes sense.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_das16_cs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index f82db29..95fa7e2 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -19,8 +19,8 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
-    PCMCIA support code for the is adapted from the dummy_cs.c driver
-    of the Linux PCMCIA Card Services package.
+    PCMCIA support code for this driver is adapted from the dummy_cs.c
+    driver of the Linux PCMCIA Card Services package.
 
     The initial developer of the original code is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
-- 
1.7.11


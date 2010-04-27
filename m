Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0D0B2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:28:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47275 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab0D0B2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:28:40 -0400
Date: Tue, 27 Apr 2010 11:28:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Steve deRosier <steve@cozybit.com>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20100427112839.0627524c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Today's linux-next merge of the wireless tree got a conflicts in
drivers/net/wireless/libertas_tf/cmd.c and
drivers/net/wireless/libertas_tf/main.c between commit
5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from Linus' tree and commit
e9bd5bcde7af27ebb92bb866afde5ef5e4f3dc6c ("libertastf: add configurable
debug messages") from the wireless tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/libertas_tf/cmd.c
index b620daf,22645e4..0000000
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@@ -7,8 -7,7 +7,9 @@@
   *  the Free Software Foundation; either version 2 of the License, or (at
   *  your option) any later version.
   */
 +#include <linux/slab.h>
 +
+ #include "deb_defs.h"
  #include "libertas_tf.h"
  
  static const struct channel_range channel_ranges[] = {
diff --cc drivers/net/wireless/libertas_tf/main.c
index 7533a23,3b1db84..0000000
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@@ -7,8 -7,7 +7,9 @@@
   *  the Free Software Foundation; either version 2 of the License, or (at
   *  your option) any later version.
   */
 +#include <linux/slab.h>
 +
+ #include "deb_defs.h"
  #include "libertas_tf.h"
  #include "linux/etherdevice.h"
  

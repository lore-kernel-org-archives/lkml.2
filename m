Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab0DGBAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:00:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57436 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab0DGBAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:00:39 -0400
Date: Wed, 7 Apr 2010 11:00:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20100407110035.217b024b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/video/meye.c between commit
5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from Linus' tree and commit
b214778b09229f9135e715bf346c25f98c8ac1e4 ("V4L/DVB: meye: remove last
V4L1 remnants from the code and add v4l2_device") from the v4l-dvb tree.

Just context changes.  I fixed it up (see below) and can carry the change
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/video/meye.c
index 4404e5e,9c7f282..0000000
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@@ -30,9 -30,9 +30,10 @@@
  #include <linux/pci.h>
  #include <linux/sched.h>
  #include <linux/init.h>
- #include <linux/videodev.h>
+ #include <linux/videodev2.h>
 +#include <linux/gfp.h>
  #include <media/v4l2-common.h>
+ #include <media/v4l2-device.h>
  #include <media/v4l2-ioctl.h>
  #include <asm/uaccess.h>
  #include <asm/io.h>

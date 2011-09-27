Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1I0GLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 02:11:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:51569 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1I0GLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 02:11:06 -0400
Date: Tue, 27 Sep 2011 16:10:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Igor M. Liplianin" <liplianin@netup.ru>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20110927161055.05bbb0586fffbfbb2307f30b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/misc/altera-stapl/altera.c between commit cff4fa8415a3 ("[media]
altera-stapl: it is time to move out from staging") from the v4l-dvb tree
and commit 99c978529a40 ("staging: Add module.h to drivers/staging
users") from the staging tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

Mauro, you could, of course, apply Paul's patch to the file in its new
location.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/altera-stapl/altera.c
index 1a2c50b,c2eff6a..0000000
--- a/drivers/misc/altera-stapl/altera.c
+++ b/drivers/misc/altera-stapl/altera.c
@@@ -28,7 -28,8 +28,8 @@@
  #include <linux/string.h>
  #include <linux/firmware.h>
  #include <linux/slab.h>
+ #include <linux/module.h>
 -#include "altera.h"
 +#include <misc/altera.h>
  #include "altera-exprt.h"
  #include "altera-jtag.h"
  

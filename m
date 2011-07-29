Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1G2ErH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 00:47:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48702 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab1G2ErG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 00:47:06 -0400
Date: Fri, 29 Jul 2011 14:47:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the moduleh tree with the v4l-dvb tree
Message-Id: <20110729144700.d58aad0fe07e454ac7c7ece4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
sound/i2c/other/tea575x-tuner.c between commit 4522e825dbfc ("[media]
tea575x: convert to control framework") from the v4l-dvb tree and commit
a319a4d494d5 ("sound: Add module.h to the previously silent sound users")
from the moduleh tree.

Just context changes.  I fixed it up (see below) anc can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/i2c/other/tea575x-tuner.c
index 484a35b,c65c624..0000000
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@@ -25,8 -25,9 +25,9 @@@
  #include <linux/init.h>
  #include <linux/slab.h>
  #include <linux/version.h>
+ #include <linux/module.h>
 -#include <sound/core.h>
 +#include <media/v4l2-dev.h>
 +#include <media/v4l2-ioctl.h>
  #include <sound/tea575x-tuner.h>
  
  MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");

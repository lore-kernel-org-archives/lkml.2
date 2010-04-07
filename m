Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0DGDTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 23:19:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52666 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab0DGDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 23:18:56 -0400
Date: Wed, 7 Apr 2010 13:18:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Barry Song <21cnbao@gmail.com>
Subject: linux-next: manual merge of the sound tree with Linus' tree
Message-Id: <20100407131854.d58079df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/soc/codecs/ad1938.c between commit
5a0e3ad6af8660be21ca98a971cd00f331318c05 ("include cleanup: Update gfp.h
and slab.h includes to prepare for breaking implicit slab.h inclusion
from percpu.h") from Linus' tree and commit
a1533d94c6b930ef4263941adfd1e1132ca95627 ("ASoC: rename ad1938 to ad193x
and add support for ad1936/7/8/9") from the sound tree.

The latter moved the file that the former modified.  I applied the
following merge fixup patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 7 Apr 2010 13:09:13 +1000
Subject: [PATCH] sound: ASoC; merge fixup for slab.h changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/soc/codecs/ad193x.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 4bfd66b..08c7e10 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
-- 
1.7.0.3

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

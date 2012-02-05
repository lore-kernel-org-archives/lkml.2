Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2BEA1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 19:27:19 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10775 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2BEA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 19:27:18 -0500
Date: Sun, 5 Feb 2012 01:27:44 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: alsa-devel@alsa-project.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH] Sound, emu8000: Remove duplicate linux/moduleparam.h include
 from emu8000_patch.c
Message-ID: <alpine.LNX.2.00.1202050126080.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The header 'linux/moduleparam.h' is included twice in
'sound/isa/sb/emu8000_patch.c'. Once is enough.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/isa/sb/emu8000_patch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/isa/sb/emu8000_patch.c b/sound/isa/sb/emu8000_patch.c
index e09f144..c99c607 100644
--- a/sound/isa/sb/emu8000_patch.c
+++ b/sound/isa/sb/emu8000_patch.c
@@ -22,7 +22,6 @@
 #include "emu8000_local.h"
 #include <asm/uaccess.h>
 #include <linux/moduleparam.h>
-#include <linux/moduleparam.h>
 
 static int emu8000_reset_addr;
 module_param(emu8000_reset_addr, int, 0444);
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


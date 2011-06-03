Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1FCJ3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:29:35 -0400
Received: from mail.perches.com ([173.55.12.10]:2470 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab1FCJ3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:29:32 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 4/5] ALSA: asihpi: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:49 -0700
Message-Id: <ffe619f08dd89fbeefb13bcba0a6e98f9662c8f8.1307092589.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1307092588.git.joe@perches.com>
References: <cover.1307092588.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the normal include style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/pci/asihpi/hpidspcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/asihpi/hpidspcd.c b/sound/pci/asihpi/hpidspcd.c
index fb311d8..5c6ea11 100644
--- a/sound/pci/asihpi/hpidspcd.c
+++ b/sound/pci/asihpi/hpidspcd.c
@@ -60,7 +60,7 @@ struct code_header {
 	    HPI_VER_MINOR(HPI_VER) * 100 + HPI_VER_RELEASE(HPI_VER)))
 
 /***********************************************************************/
-#include "linux/pci.h"
+#include <linux/pci.h>
 /*-------------------------------------------------------------------*/
 short hpi_dsp_code_open(u32 adapter, struct dsp_code *ps_dsp_code,
 	u32 *pos_error_code)
-- 
1.7.5.rc3.dirty


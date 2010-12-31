Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab0LaRiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:38:16 -0500
Received: from mail-px0-f194.google.com ([209.85.212.194]:41901 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab0LaRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:38:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=m7md5RIYWY0PyXE1nyPcx+FYrJInDmyYilyGpTiJLeuWxg8klc69mip+ZHFKgnY91c
         9dTKvgKd8JIUJhF+blqha4viZ9pX3Qpadg9v5w8dCy5VoHt5IDSPWKMAKvCPqASBam8a
         ONMNR2EA14zfJIG+9sHwgVx5dn228DfV0R4xk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/7] dma/shdma.c Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:38:17 -0800
Message-Id: <1293817097-7945-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/dma/shdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index 85ffd5e..72d25d9 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -740,7 +740,7 @@ static void sh_chan_xfer_ld_queue(struct sh_dmae_chan *sh_chan)
 		return;
 	}
 
-	/* Find the first not transferred desciptor */
+	/* Find the first not transferred descriptor */
 	list_for_each_entry(desc, &sh_chan->ld_queue, node)
 		if (desc->mark == DESC_SUBMITTED) {
 			dev_dbg(sh_chan->dev, "Queue #%d to %d: %u@%x -> %x\n",
-- 
1.6.5.2.180.gc5b3e


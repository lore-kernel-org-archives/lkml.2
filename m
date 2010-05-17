Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0EQSIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:08:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59532 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0EQSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=k80ECPFzNXnVE0nIkUcl6iJ/7T6Msibo9fiLTpFnuYsaBrlizpXIVZqyymZoBW/fEG
         iOv86s5VfsRQgmMNmf+NdXvlBBwrJKT9l8XLdyr46F6pHxiJly7L3dI2p+c+URrysnJi
         Jv90tJaaijcHiLMebE3B5Q+17x3c1dAzUTN9M=
Subject: Patch: ni_tio.c
From: Samuel Richardson <sam.j.richardson@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 19:08:18 +0100
Message-ID: <1274119698.5638.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bfe4b5738e2f9cc6d7f5e4fee6d65c66889e18a8 Mon Sep 17 00:00:00 2001
From: Samuel Richardson <sam.j.richardson@gmail.com>
Date: Mon, 17 May 2010 18:09:48 +0100
Subject: [PATCH] Staging: comedi: fixed brace coding style issue in ni_tio.c
 This is a patch to the ni_tio.c file that fixes a brace warning found by the checkpatch.pl tool
 Signed-off-by: Samuel Richardson <sam.j.richardson@gmail.com>

---
 drivers/staging/comedi/drivers/ni_tio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index 13e5b26..6621e94 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -1688,11 +1688,10 @@ static unsigned ni_tio_next_load_register(struct ni_gpct *counter)
 					    NITIO_Gxx_Status_Reg(counter->
 								 counter_index));
 
-	if (bits & Gi_Next_Load_Source_Bit(counter->counter_index)) {
+	if (bits & Gi_Next_Load_Source_Bit(counter->counter_index))
 		return NITIO_Gi_LoadB_Reg(counter->counter_index);
-	} else {
+	else
 		return NITIO_Gi_LoadA_Reg(counter->counter_index);
-	}
 }
 
 int ni_tio_winsn(struct ni_gpct *counter, struct comedi_insn *insn,
-- 
1.6.6.1




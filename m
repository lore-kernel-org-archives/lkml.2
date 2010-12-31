Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0LaRuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:50:25 -0500
Received: from mail-gy0-f194.google.com ([209.85.160.194]:61546 "EHLO
	mail-gy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0LaRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dc0nrxnLw7/49fAK+ppdaHMG6BOxWOHchhyvhWxMxSSN20pnCpsBthyZiOcfgegqpw
         G1RSFtgr7HluXAG93Fhq2kt5PP4ojEnldiPYIuLHxJJvq6Lug82IEA+6NTjF3MI1q4HY
         FW0VIyRSA1wegOYxJW7U2IbQfAtCGYiJz3oxI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        grant.likely@secretlab.ca,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] spi/spi_topcliff_pch.c Typo change threhold to threshold
Date: Fri, 31 Dec 2010 09:50:31 -0800
Message-Id: <1293817831-8263-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch changes a typo from "threhold" to "threshold".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/spi/spi_topcliff_pch.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 58e187f..be451e3 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -677,7 +677,7 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 {
 	/* enable interrupts */
 	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
-		/* set receive threhold to PCH_RX_THOLD */
+		/* set receive threshold to PCH_RX_THOLD */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
 				   PCH_RX_THOLD << SPCR_TFIC_FIELD,
 				   ~MASK_TFIC_SPCR_BITS);
@@ -685,7 +685,7 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
 				   SPCR_RFIE_BIT | SPCR_TFIE_BIT, 0);
 	} else {
-		/* set receive threhold to maximum */
+		/* set receive threshold to maximum */
 		pch_spi_setclr_reg(data->master, PCH_SPCR,
 				   PCH_RX_THOLD_MAX << SPCR_TFIC_FIELD,
 				   ~MASK_TFIC_SPCR_BITS);
-- 
1.6.5.2.180.gc5b3e


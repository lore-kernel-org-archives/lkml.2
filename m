Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab2GBOpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:45:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60852 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2GBOpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:45:03 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH NEXT]staging "telephony" Fix typos.
Date: Mon,  2 Jul 2012 07:44:41 -0700
Message-Id: <1341240281-25590-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes typos found while reading through staging "telephony".

 drivers/staging/telephony/ixj.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/telephony/ixj.c b/drivers/staging/telephony/ixj.c
index fd7757a..b303c91 100644
--- a/drivers/staging/telephony/ixj.c
+++ b/drivers/staging/telephony/ixj.c
@@ -7094,7 +7094,7 @@ static int ixj_selfprobe(IXJ *j)
 	for (cnt = 0; cnt < 35; cnt++)
 		j->ixj_signals[cnt] = SIGIO;
 
-	/* Set the excetion signal enable flags */
+	/* Set the exception signal enable flags */
 	j->ex_sig.bits.dtmf_ready = j->ex_sig.bits.hookstate = j->ex_sig.bits.flash = j->ex_sig.bits.pstn_ring =
 	j->ex_sig.bits.caller_id = j->ex_sig.bits.pstn_wink = j->ex_sig.bits.f0 = j->ex_sig.bits.f1 = j->ex_sig.bits.f2 =
 	j->ex_sig.bits.f3 = j->ex_sig.bits.fc0 = j->ex_sig.bits.fc1 = j->ex_sig.bits.fc2 = j->ex_sig.bits.fc3 = 1;
@@ -7132,7 +7132,7 @@ IXJ *ixj_pcmcia_probe(unsigned long dsp, unsigned long xilinx)
 	return j;
 }
 
-EXPORT_SYMBOL(ixj_pcmcia_probe);		/* Fpr PCMCIA */
+EXPORT_SYMBOL(ixj_pcmcia_probe);		/* For PCMCIA */
 
 static int ixj_get_status_proc(char *buf)
 {
-- 
1.7.5.4


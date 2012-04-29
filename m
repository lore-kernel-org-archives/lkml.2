Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2D2NU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:20:58 -0400
Received: from nm29-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.159]:45082 "HELO
	nm29-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752386Ab2D2NU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:20:56 -0400
X-Yahoo-Newman-Id: 688277.58266.bm@smtp106.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WANPcW0VM1kB_UWu..NZ0_CYtnbpmsXy8tKlyge6X.6fEhc
 H__H0CbrGIHlhX0H1SbjtQW3esoXxvfk8xIK_rLax3jRhLq9V1VFi00L5O_I
 2Eblm4U.8ia74E.78n9yKfty5hp8U_qyOQffYIWX.twXfS1zV6qMfWQueaeV
 jX20kV9hE0zsdaXhrDY5gNPM.XW3k0LD2V_a2CsdrtNaK3pvAFr0WGM3P9Db
 d0a3OYdWFMYdyTrpLRTqXSE8a0_XAXiFfm4fTkWOAZdfjMKmAbbsKefo2YlB
 ZfjlGkOJophroGZs6X_4S2qDAteRVA39FZV3tqIf328AGgZuPvzi2gPWyO3.
 qild8X6y8nM.KtQlg0kNvZ2NMqegOV8RCrg58Eh_y_tAU1XC6N.zUf4o5ZUa
 58x.VhtdWZZnCczfU6wLtUTpjxWarwy4-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Sun, 29 Apr 2012 18:53:37 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 02/02 ] fixed coding style issue relating to spaces
Message-ID: <20120429132337.GB3435@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello 

Fixed coding style issues relating to spaces
in sound/usb/card.h


>From a9bda96c7af932f16ff25759a9f993ebf0644803 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 29 Apr 2012 18:35:16 +0530
Subject: [PATCH 10/10] sound:Fixed coding style errors related to spaces.

Fixed coding style errors relating to spaces in
sound/usb/card.h

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 sound/usb/card.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index a39edcc..c5976fb 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -70,11 +70,11 @@ struct snd_usb_substream {
 	unsigned int curpacksize;	/* current packet size in bytes (for capture) */
 	unsigned int curframesize;	/* current packet size in frames (for capture) */
 	unsigned int syncmaxsize;	/* sync endpoint packet size */
-	unsigned int fill_max: 1;	/* fill max packet size always */
+	unsigned int fill_max:1;	/* fill max packet size always */
 	unsigned int txfr_quirk:1;	/* allow sub-frame alignment */
 	unsigned int fmt_type;		/* USB audio format type (1-3) */
 
-	unsigned int running: 1;	/* running status */
+	unsigned int running:1;	/* running status */
 
 	unsigned int hwptr_done;	/* processed byte position in the buffer */
 	unsigned int transfer_done;		/* processed frames since last period update */
-- 
1.7.9

-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

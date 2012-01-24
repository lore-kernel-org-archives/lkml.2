Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808Ab2AXCsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:48:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932776Ab2AXCsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:48:07 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.812071475@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Miroslav Slugen <thunder.mmm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [111/129] [media] tuner: Fix numberspace conflict between xc4000 and pti 5nf05 tuners
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1092
Lines: 35

From: Miroslav Slugen <thunder.mmm@gmail.com>

commit cd4ca7afc61d3b18fcd635002459fb6b1d701099 upstream.

Update xc4000 tuner definition, number 81 is already in use by
TUNER_PARTSNIC_PTI_5NF05.

Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/media/tuner.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -127,7 +127,6 @@
 #define TUNER_PHILIPS_FMD1216MEX_MK3	78
 #define TUNER_PHILIPS_FM1216MK5		79
 #define TUNER_PHILIPS_FQ1216LME_MK3	80	/* Active loopthrough, no FM */
-#define TUNER_XC4000			81	/* Xceive Silicon Tuner */
 
 #define TUNER_PARTSNIC_PTI_5NF05	81
 #define TUNER_PHILIPS_CU1216L           82
@@ -136,6 +135,8 @@
 #define TUNER_PHILIPS_FQ1236_MK5	85	/* NTSC, TDA9885, no FM radio */
 #define TUNER_TENA_TNF_5337		86
 
+#define TUNER_XC4000			87	/* Xceive Silicon Tuner */
+
 /* tv card specific */
 #define TDA9887_PRESENT 		(1<<0)
 #define TDA9887_PORT1_INACTIVE 		(1<<1)



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab0G3SKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:10:23 -0400
Received: from kroah.org ([198.145.64.141]:59174 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932580Ab0G3R5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:34 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:49 2010
Message-Id: <20100730175149.824572043@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [175/205] V4L/DVB: budget: Select correct frontends
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit d46b36e7f927772bb72524dc9f1e384e3cb4a975 upstream.

Update the Kconfig selections to match the code.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/dvb/ttpci/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -68,13 +68,14 @@ config DVB_BUDGET
 	select DVB_VES1820 if !DVB_FE_CUSTOMISE
 	select DVB_L64781 if !DVB_FE_CUSTOMISE
 	select DVB_TDA8083 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10021 if !DVB_FE_CUSTOMISE
-	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select DVB_S5H1420 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10086 if !DVB_FE_CUSTOMISE
 	select DVB_TDA826X if !DVB_FE_CUSTOMISE
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
+	select DVB_ISL6423 if !DVB_FE_CUSTOMISE
+	select DVB_STV090x if !DVB_FE_CUSTOMISE
+	select DVB_STV6110x if !DVB_FE_CUSTOMISE
 	help
 	  Support for simple SAA7146 based DVB cards (so called Budget-
 	  or Nova-PCI cards) without onboard MPEG2 decoder, and without



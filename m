Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0IIW2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:28:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58564 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab0IIW2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:28:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=N/66Zs67/eufHSabkww18swXlxCpwTBLHxKTcOKqzqpNtKGp8+GrLV8i4agiJsXSu1
         /GEu+Vga5Ujq17M5EwvQJvJ48jfwbBoPsb9Jj/5zuJsuKGS10ILA/DdgdzFf6KV0EhFR
         i2sLvvLfp3RM3IMrJOsCKBjJ3LQsvIQrz3MEQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 069/223]drivers/media/dvb/ttpci/av7110.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:28:30 -0700
Message-Id: <1284071316-7834-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
References: <1284071316-7834-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/dvb/ttpci/av7110.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 703d9be..87279d9 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -2290,13 +2290,7 @@ static int frontend_init(struct av7110 *av7110)
 /* Budgetpatch note:
  * Original hardware design by Roberto Deza:
  * There is a DVB_Wiki at
- * http://212.227.36.83/linuxtv/wiki/index.php/Main_Page
- * where is described this 'DVB TT Budget Patch', on Card Modding:
- * http://212.227.36.83/linuxtv/wiki/index.php/DVB_TT_Budget_Patch
- * On the short description there is also a link to a external file,
- * with more details:
- * http://perso.wanadoo.es/jesussolano/Ttf_tsc1.zip
- *
+ * http://www.linuxtv.org/
  * New software triggering design by Emard that works on
  * original Roberto Deza's hardware:
  *
-- 
1.7.2.1


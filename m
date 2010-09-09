Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0IIWY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:24:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab0IIWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sw9AGZlY2f42I1C7k+MHOodP4tTTuC+LpkRZBG3FxCxl8nMgBnhlN14o7U1hBBzJJ3
         piRRvji1EtJqVmRijZBEUsT6K8DhN01CiwNmkzM/YRJkBvjahCzsiF9YJnqKb4A04Qrd
         gEBNhcQtULlwT+6B9fCSoRSnkbeOzQ+evOY64=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 012/223]drivers/char/ipmi/ipmi_si_intf.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:24:48 -0700
Message-Id: <1284071091-7676-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
References: <1284071091-7676-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/ipmi/ipmi_si_intf.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 3822b4f..967e620 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1971,8 +1971,7 @@ static int acpi_gpe_irq_setup(struct smi_info *info)
 
 /*
  * Defined at
- * http://h21007.www2.hp.com/portal/download/files
- * /unprot/hpspmi.pdf
+ * http://h21007.www2.hp.com/portal/download/files/unprot/hpspmi.pdf
  */
 struct SPMITable {
 	s8	Signature[4];
-- 
1.7.2.1


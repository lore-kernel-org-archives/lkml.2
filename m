Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab0IIWoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:44:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47970 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab0IIWoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z/XFzIAmviwGzSl0LZMlkfiPsOuM8CAmTGiCh7mvUG76vQhXMOeennj2KevS0I7x5q
         1HPom4FOFMJ/5eq2Aq1D0uu2sOjCGkRMONjdNLa6mtwkVMowoBx60ou4ebBjDPy2OA7g
         UK7BBKTOyzHHdZF7wzt82haMG6HiWX52whEy0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 192/223]drivers/staging/comedi/drivers/cb_pcimdas.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:44:10 -0700
Message-Id: <1284072253-8390-12-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
References: <1284072253-8390-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/comedi/drivers/cb_pcimdas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index ced346a..e4cf861 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -37,7 +37,7 @@ Configuration Options:
 Developed from cb_pcidas and skel by Richard Bytheway (mocelet@sucs.org).
 Only supports DIO, AO and simple AI in it's present form.
 No interrupts, multi channel or FIFO AI, although the card looks like it could support this.
-See http://www.measurementcomputing.com/PDFManuals/pcim-das1602_16.pdf for more details.
+See http://www.mccdaq.com/specs.aspx for more details.
 */
 
 #include "../comedidev.h"
-- 
1.7.2.1


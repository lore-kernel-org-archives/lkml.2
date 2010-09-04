Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab0IDXI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 19:08:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56287 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0IDXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 19:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=hI6R2k/5MPvIjfJong+mZXU3XMB4Xc6hyBFNkDG2AKnx0YiKPwMBZSYDpJzHGNavmU
         Rh2SyDkYhZaiefW7iyigGsgRX+XZgEMfTdtBb+A3yayxpoP+xQ1rHF3G4ig2pOqIu8aI
         MH49EdmCzxnSwznHTFwMAtOO2i4CG/Zqq4PFg=
Subject: [PATCH 3/4] staging: xgifb: Removes unused variable
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Huang Weiyi <weiyi.huang@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 Sep 2010 19:08:20 -0400
Message-ID: <1283641700.9641.6.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2cba4c4..4db5986 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -3491,7 +3491,6 @@ module_init(xgifb_init);
 static char         *mode = NULL;
 static int          vesa = 0;
 static unsigned int rate = 0;
-static unsigned int crt1off = 1;
 static unsigned int mem = 0;
 static char         *forcecrt2type = NULL;
 static int          forcecrt1 = -1;
-- 
1.7.0.4




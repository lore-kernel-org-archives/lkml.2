Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab0IKQfx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:35:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56856 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0IKQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F/+zlREG8W26VF3SCIAouhdTFpwjbv9baX3LvVLXUxiszF5qQvzMFfNenidWEx6Swl
         244PqzmmLqcSal+BjDHLBTxwI0v0D0pAbnNkL/qqFs/ReIU1slfFK0nWbLo8cvuyiP6L
         tZCLunoWtfwdmGVvvCXm1ViohfQrm3Ll0Amak=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 7/8]sound/pci/intel8x0.c Update broken web addresses.
Date: Sat, 11 Sep 2010 09:35:27 -0700
Message-Id: <1284222928-4150-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
References: <1284222928-4150-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 sound/pci/intel8x0.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 4677492..56fbf3a 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -716,7 +716,7 @@ static void snd_intel8x0_setup_periods(struct intel8x0 *chip, struct ichdev *ich
  * Intel 82443MX running a 100MHz processor system bus has a hardware bug,
  * which aborts PCI busmaster for audio transfer.  A workaround is to set
  * the pages as non-cached.  For details, see the errata in
- *	http://www.intel.com/design/chipsets/specupdt/245051.htm
+ *	http://www.intel.com/p/en_US/business/design	
  */
 static void fill_nocache(void *buf, int size, int nocache)
 {
-- 
1.7.2.1


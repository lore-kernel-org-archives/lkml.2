Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2BRRFA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 12:05:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58972 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2BRREm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:04:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of standby24x7@gmail.com designates 10.101.22.16 as permitted sender) smtp.mail=standby24x7@gmail.com; dkim=pass header.i=standby24x7@gmail.com
MIME-Version: 1.0
Date: Sun, 19 Feb 2012 02:04:41 +0900
Message-ID: <CALLJCT29KvHdf0ZKnShA=OnYuMpWqFv7i1PnZiJ18seb-rg2+w@mail.gmail.com>
Subject: [PATCH Resend] [trivial] video: Fix typo in epson frambuffer driver
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "contant" to "contact" in
drivers/video/s1d13xxxfb.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

---
 drivers/video/s1d13xxxfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 28b1c6c..b6f6b7c 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -864,7 +864,7 @@ s1d13xxxfb_probe(struct platform_device *pdev)
              printk(KERN_INFO PFX
                      "unknown chip production id %i, revision %i\n",
                      prod_id, revision);
-               printk(KERN_INFO PFX "please contant maintainer\n");
+               printk(KERN_INFO PFX "please contact maintainer\n");
              goto bail;
      }

--
1.7.6.5

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab3AAC7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 21:59:13 -0500
Received: from nigelcunningham.com.au ([178.79.133.97]:44679 "EHLO
	nigelcunningham.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3AAC7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 21:59:11 -0500
Message-ID: <50E250FC.3000003@nigelcunningham.com.au>
Date: Tue, 01 Jan 2013 13:59:08 +1100
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3] Re: New Defect(s) reported by Coverity Scan
References: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
In-Reply-To: <C0A4ACBB26D853488EA0C68388B70268168CDC32@BLUPRD0511MB401.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b4a7ab768df17e1cda7d0ae8744e986215a644c3 Mon Sep 17 00:00:00 2001
From: Nigel Cunningham <nigel@nigelcunningham.com.au>
Date: Tue, 1 Jan 2013 13:53:51 +1100
Subject: [PATCH] Remove unused variable in rbd_dev_probe_update_spec.

As an aside to the previous patch, remove the unused local
variable reply_buf in that function.

Signed-off-by: Nigel Cunningham <nigel@nigelcunningham.com.au>
---
  drivers/block/rbd.c |    2 --
  1 file changed, 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index ba4dd66..dccb6e4 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2592,7 +2592,6 @@ static int rbd_dev_probe_update_spec(struct 
rbd_device *rbd_dev)
  {
      struct ceph_osd_client *osdc;
      const char *name;
-    void *reply_buf = NULL;
      int ret;

      if (rbd_dev->spec->pool_name)
@@ -2636,7 +2635,6 @@ static int rbd_dev_probe_update_spec(struct 
rbd_device *rbd_dev)

      return 0;
  out_err:
-    kfree(reply_buf);
      kfree(rbd_dev->spec->pool_name);
      rbd_dev->spec->pool_name = NULL;

-- 
1.7.10.4


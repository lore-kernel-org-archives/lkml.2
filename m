Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1IDLOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 07:14:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36919 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab1IDLON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 07:14:13 -0400
Message-ID: <4E635D74.7090808@gmail.com>
Date: Sun, 04 Sep 2011 19:13:56 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] trival: md_k.h should be md.h in the beginning comment of
 file md.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.1-rc3.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 drivers/md/md.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1e586bb..4b304ad 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1,5 +1,5 @@
 /*
-   md_k.h : kernel internal structure of the Linux MD driver
+   md.h : kernel internal structure of the Linux MD driver
           Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
 	  
    This program is free software; you can redistribute it and/or modify
-- 
1.7.1


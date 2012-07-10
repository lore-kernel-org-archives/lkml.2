Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2GJK2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 06:28:13 -0400
Received: from fep24.mx.upcmail.net ([62.179.121.44]:48554 "EHLO
	fep24.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2GJK2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 06:28:12 -0400
X-Greylist: delayed 1030 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 06:28:11 EDT
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <4FFBFF93.7030201@odi.ch>
Date: Tue, 10 Jul 2012 12:10:27 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mei: module version
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LMS daemon expects a /sys/modules/mei/version file with, a four 
digit version number.

see
http://software.intel.com/en-us/articles/download-the-latest-intel-amt-open-source-drivers/

Signed-off-by: Ortwin Glück <odi@odi.ch>
---
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7de1389..cee72bd 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1229,3 +1229,4 @@ module_exit(mei_exit_module);
  MODULE_AUTHOR("Intel Corporation");
  MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
  MODULE_LICENSE("GPL v2");
+MODULE_VERSION("1.0.0.0");
-- 
1.7.8.6


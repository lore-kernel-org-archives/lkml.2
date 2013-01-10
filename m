Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3AJKPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:15:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab3AJKPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:15:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,444,1355068800"; 
   d="scan'208";a="6559375"
Message-ID: <50EE9175.2060906@cn.fujitsu.com>
Date: Thu, 10 Jan 2013 18:01:25 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: hpa@zytor.com, rob@landley.net, Greg KH <gregkh@linuxfoundation.org>
CC: linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documention/x86: fix arch/x86/include/asm/bootparam.h
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 18:03:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/10 18:14:55,
	Serialize complete at 2013/01/10 18:14:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is now arch/x86/include/uapi/asm/bootparam.h.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 Documentation/x86/zero-page.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index cf5437d..9723e2a 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -3,7 +3,7 @@ protocol of kernel. These should be filled by bootloader or 16-bit
 real-mode setup code of the kernel. References/settings to it mainly
 are in:
 
-  arch/x86/include/asm/bootparam.h
+  arch/x86/include/uapi/asm/bootparam.h
 
 
 Offset	Proto	Name		Meaning
-- 
1.7.1

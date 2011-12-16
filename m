Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab1LPNjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 08:39:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260Ab1LPNjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 08:39:17 -0500
X-Authority-Analysis: v=2.0 cv=Z6Nu7QtA c=1 sm=0 a=mpMdnlmFKti1S5SNY1DT+A==:17 a=TRgVYD6ZyiEA:10 a=j1JXAuFf32wA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=xzupBzvRGLdXdvQUcVIA:9 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=mpMdnlmFKti1S5SNY1DT+A==:117
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.85
Date: Fri, 16 Dec 2011 07:39:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: rdunlap@xenotime.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: Add explanation for two missing bits in
 the tainted flag
Message-ID: <4eeb4a03.gOyP8gudQ1A+Jo2u%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the bits in the tainted flag are not documented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/Documentation/sysctl/kernel.txt
===================================================================
--- wireless-testing-new.orig/Documentation/sysctl/kernel.txt
+++ wireless-testing-new/Documentation/sysctl/kernel.txt
@@ -579,6 +579,8 @@ can be ORed together:
         instead of using the one provided by the hardware.
  512 - A kernel warning has occurred.
 1024 - A module from drivers/staging was loaded.
+2048 - The system is working around a severe firmware bug.
+4096 - An out-of-tree module has been loaded.
 
 ==============================================================
 

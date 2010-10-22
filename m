Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0JVSbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:31:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50964 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab0JVSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=j1KGP9uUwJoDjzXUQ47cT0MNx5naV8Hm7CJOqsYvpD5+n0PS9NG129suT833YJFW+F
         sqMfZZ/QhrlyGiK1cSDhOrWzIUd3OlbFRBsGr/v64Sz7mWMXufmjPZjAE2vE8v26Iaci
         k0OACDqMzukJFwef4Y4BNVsOSYY2TBVJpOCDc=
Message-ID: <4CC1D710.1040704@gmail.com>
Date: Fri, 22 Oct 2010 20:25:20 +0200
From: "N.P.S." <napohybelskurwysynom2010@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; pl; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [RFC][PATCH 8/8] Removal of dead code from arch/h8300/kernel/time.c
References: <4CC1D2D5.9050009@gmail.com>
In-Reply-To: <4CC1D2D5.9050009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit df836d3ba767abc31e96ba95db318f4d023d9023
Author: N.P.S <napohybelskurwysynom2010@gmail.com>
Date:   Thu Oct 21 23:11:58 2010 +0200

    Removal of dead code from arch/h8300/kernel/time.c
    
    Signed-off-by: Zimny Lech <napohybelskurwysynom2010@gmail.com>
    CC: Yoshinori Sato <ysato@users.sourceforge.jp>
    CC: <linux-kernel@vger.kernel.org>

diff --git a/arch/h8300/kernel/time.c b/arch/h8300/kernel/time.c
index 165005a..ebc3de3 100644
--- a/arch/h8300/kernel/time.c
+++ b/arch/h8300/kernel/time.c
@@ -51,9 +51,6 @@ void read_persistent_clock(struct timespec *ts)
 	year = 1980;
 	mon = day = 1;
 	hour = min = sec = 0;
-#ifdef CONFIG_H8300_GETTOD
-	h8300_gettod (&year, &mon, &day, &hour, &min, &sec);
-#endif
 	if ((year += 1900) < 1970)
 		year += 100;
 	ts->tv_sec = mktime(year, mon, day, hour, min, sec);

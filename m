Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2DHKBN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 06:01:13 -0400
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:41820 "HELO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754010Ab2DHKBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 06:01:12 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Apr 2012 06:01:12 EDT
X-Yahoo-Newman-Id: 828872.99053.bm@smtp104.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Yd6v0oMVM1mSResjyaJbezQLSLTZ0sjY4CsRZPRKgOADD7p
 P6LvogUOJd0936qDWwPnHj59emOsBO9FTyObo7H2SZZyfaKyzYceI027s7F8
 idzA8Wcs059HJC99x5LySB1jK6v4bqyvFnGxyaLtVKQqUKDHmDJR50eiuUHI
 9d1SzI5OAwv710cUZq81b85ot6SEbnsQEP0G1o6LqktnE5qEhB3y9ECbJ4ig
 zTmsfCmeCp0LyMZYJS.Llk.3FTHOURv45YgNaDaS5ml3V7uTshna4UYZTDfs
 DLAObTUhzaHU4GRMeqKis4OFBruwGAYBEJVZs32N9bZI3W0yw1HY09mGGoy8
 qCKXued5Eg0plC5FhvL6Z6KfbNRCdaA5L37BKohcPNEbB7fI_kGTZ0tlUs9K
 bqkoyf.lfWqChx_guD5t9hJIeCh8Z5IW.
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Sun, 8 Apr 2012 15:26:45 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: fixed coding style issues
Message-ID: <20120408095645.GA2919@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello ...

I have fixed some coding style issues
in net/core/utils.c.

Patch is available as attachment.
Please see the attachment.

Thanks.
/Jeffrin.

-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

--17pEHd4RhPHOinZp
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0006-net-Fixed-coding-style-issues-relating-to-braces.patch"

>From fa37bfd6c2ef8ff81b38ad9dd4467a727d6def81 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 8 Apr 2012 00:09:11 +0530
Subject: [PATCH 6/6] net: Fixed coding style issues relating to braces.

Fixed coding style issues in net/core/utils.c
in relation with braces placement.
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/core/utils.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/core/utils.c b/net/core/utils.c
index 386e263f..c2e8b41 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -59,14 +59,11 @@ __be32 in_aton(const char *str)
 	int i;
 
 	l = 0;
-	for (i = 0; i < 4; i++)
-	{
+	for (i = 0; i < 4; i++)	{
 		l <<= 8;
-		if (*str != '\0')
-		{
+		if (*str != '\0') {
 			val = 0;
-			while (*str != '\0' && *str != '.' && *str != '\n')
-			{
+			while (*str != '\0' && *str != '.' && *str != '\n') {
 				val *= 10;
 				val += *str - '0';
 				str++;
-- 
1.7.9


--17pEHd4RhPHOinZp--

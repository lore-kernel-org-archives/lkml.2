Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab2DYOGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:06:22 -0400
Received: from nm23.bullet.mail.sp2.yahoo.com ([98.139.91.93]:34791 "HELO
	nm23.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758295Ab2DYOGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:06:20 -0400
X-Yahoo-Newman-Id: 67546.89131.bm@smtp208.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: OIqHkw0VM1mxaHDtam_aV1T6dn9F9q9_7M.elSSy0DwmOQk
 pAq.CrhLhn7jkzwGgd6.ldsj9BVsqJtrpn7fBKt8YRBE8SDri9PYdgqO8Y5U
 yj3mErZ1wQeKZdAeH6361k75csnhZRf2vheiGDiY3WemE3PJjzERW7XoxWH.
 PSHC6JtBqUglhm96V6takbZh0wlmsDMkqXMgRZaNY1fOuUQeA4sl74cdc8E6
 kQsW1EWM9RYGwEISNqz1DvE3aoIgbVYZ_4tenL4w9Fu1Bz77bkYOLXsRgw2G
 nRAqpAI.tv0kxTzAKgDWjpUfNx2bI1VQtsAzlng4kOj0mwgoPDE8Zuh_Qqqq
 xxGGccmSF0aHmSJnUceugyi8bzExHApCqS8u9iTGIGKkZ3ProEWdip9yUAHI
 ct9Rv82n9L7Os_vNZ2mHvCRyPXM4gcqgUhUFQBi51ofOe_Bh9GjJd
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Wed, 25 Apr 2012 19:38:52 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: fixed a coding style issue in net/core/sock.c
Message-ID: <20120425140852.GA3653@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello .

I have fixed a coding style issue relating
to spaces in net/core/sock.c


>From e05ee2cbdea9a888695f01358fa2ea53ddb2a49b Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Wed, 25 Apr 2012 19:17:29 +0530
Subject: [PATCH 8/8] net:Fixed a coding style issue related to spaces.

Fixed a coding style issue relating to spaces
in net/core/sock.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/core/sock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 02f8dfe..65cdc19 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2556,7 +2556,7 @@ static char proto_method_implemented(const void *method)
 }
 static long sock_prot_memory_allocated(struct proto *proto)
 {
-	return proto->memory_allocated != NULL ? proto_memory_allocated(proto): -1L;
+	return proto->memory_allocated != NULL ? proto_memory_allocated(proto) : -1L;
 }
 
 static char *sock_prot_memory_pressure(struct proto *proto)
-- 
1.7.9



/Jeffrin.


-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

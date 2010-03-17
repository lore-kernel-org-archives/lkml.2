Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0CQFgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 01:36:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48707 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0CQFgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 01:36:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xg4gbShXDju6ik3hRQUIbCZNLsDsucMZ8KJ61pzsVZTdp+h+7Rd0n6kwO0JNoReiRq
         PhhzpXUApvXe3jKQbfK7bXfgr/PHJPXA/rzsmF9MRozr6P8pYAS0l7hslmn2iobS/O45
         pcpA8S8sgKWqkRy0FRL5NenDpAKgYeoObz2c0=
Date: Wed, 17 Mar 2010 21:35:02 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: [PATCH] Netfilter: Remove unused headers in net/netfilter/nfnetlink.c
Message-ID: <20100317133502.GB2696@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused headers in net/netfilter/nfnetlink.c

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 net/netfilter/nfnetlink.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 8eb0cc2..0794f9a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -18,12 +18,9 @@
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/kernel.h>
-#include <linux/major.h>
-#include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/sockios.h>
 #include <linux/net.h>
-#include <linux/fcntl.h>
 #include <linux/skbuff.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
-- 
1.6.5.3


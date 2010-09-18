Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab0IRTQZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:25 -0400
Received: from kroah.org ([198.145.64.141]:43882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab0IRTQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:22 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:06 2010
Message-Id: <20100918191306.824272322@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [111/129] NFS: Fix a typo in nfs_sockaddr_match_ipaddr6
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit b20d37ca9561711c6a3c4b859c2855f49565e061 upstream.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -274,7 +274,7 @@ static int nfs_sockaddr_match_ipaddr6(co
 	    sin1->sin6_scope_id != sin2->sin6_scope_id)
 		return 0;
 
-	return ipv6_addr_equal(&sin1->sin6_addr, &sin1->sin6_addr);
+	return ipv6_addr_equal(&sin1->sin6_addr, &sin2->sin6_addr);
 }
 #else	/* !defined(CONFIG_IPV6) && !defined(CONFIG_IPV6_MODULE) */
 static int nfs_sockaddr_match_ipaddr6(const struct sockaddr *sa1,



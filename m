Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab1CXT2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:28:53 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:63376 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934049Ab1CXT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v7n8uTufFZrg/kKtdjCU4DRW4orq/hpbvJh+7C8rUZlsumK0nZxX/4Hs+XVpKMYbRr
         5tyrIzzKZLmwtQ3NZKgd8uPly7A4WFuJVUJdlExb9rZpJpKaiz8wM+/2aErIikN+9yeR
         QqILrGS9jAL0lWeFbS9TrfKrPkaYLxr3KRwMQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 19/21]net remove extra comma.
Date: Thu, 24 Mar 2011 12:26:57 -0700
Message-Id: <1300994819-30930-19-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/netfilter/ipset/ip_set_bitmap_ip.c |    2 +-
 net/sunrpc/addr.c                      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index bca9699..cc29922 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -293,7 +293,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	for (; !before(ip_to, ip); ip += map->hosts) {
 		id = ip_to_id(map, ip);
-		ret = adtfn(set, &id, timeout);;
+		ret = adtfn(set, &id, timeout);
 
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 1419d0c..4195233 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -151,7 +151,7 @@ static size_t rpc_pton4(const char *buf, const size_t buflen,
 		return 0;
 
 	sin->sin_family = AF_INET;
-	return sizeof(struct sockaddr_in);;
+	return sizeof(struct sockaddr_in);
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-- 
1.7.4.1


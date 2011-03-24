Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab1CXUT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158Ab1CXUTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XcdLl7Dl8o5DujPRTFmsGqQIgiBMX8H2DecagY4bSB0yJyp1iTEtlL9Q06ub6WA2uz
         Mu6JK/44AxK6Rt7p6wQU2kWZadRzofWkXZhZ6ZBtjfBf+v/k36qOluFc8pwKk9ab8qHA
         ej1vAN0w5ni87jOoVSDJ3H3px1LT+9OxoI4eA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 19/21]net remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:38 -0700
Message-Id: <1300997920-31573-19-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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


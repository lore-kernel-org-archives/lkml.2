Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761012Ab0HFCOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 22:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760Ab0HFCN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 22:13:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] DNS: Fixes for the DNS query module
To: smfrench@gmail.com
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 06 Aug 2010 03:13:52 +0100
Message-ID: <20100806021352.29873.16452.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100806021347.29873.87087.stgit@warthog.procyon.org.uk>
References: <20100806021347.29873.87087.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for the DNS query module, including:

 (1) Use 'negative' instead of '-ve' in the documentation.

 (2) Mark the kdoc comment with '/**' on dns_query().

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/networking/dns_resolver.txt |    6 +++---
 net/dns_resolver/dns_query.c              |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/dns_resolver.txt b/Documentation/networking/dns_resolver.txt
index d8e0ce1..aefd1e6 100644
--- a/Documentation/networking/dns_resolver.txt
+++ b/Documentation/networking/dns_resolver.txt
@@ -96,9 +96,9 @@ implemented in the module can be called after doing:
      for the default query type it is just a list of comma-separated IPv4 and
      IPv6 addresses.  The caller must free the result.
 
-     The length of the result string is returned on success, and a -ve error
-     code is returned otherwise.  -EKEYREJECTED will be returned if the DNS
-     lookup failed.
+     The length of the result string is returned on success, and a negative
+     error code is returned otherwise.  -EKEYREJECTED will be returned if the
+     DNS lookup failed.
 
      If _expiry is non-NULL, the expiry time (TTL) of the result will be
      returned also.
diff --git a/net/dns_resolver/dns_query.c b/net/dns_resolver/dns_query.c
index b33e1f7..03d5255 100644
--- a/net/dns_resolver/dns_query.c
+++ b/net/dns_resolver/dns_query.c
@@ -45,7 +45,7 @@
 
 #include "internal.h"
 
-/*
+/**
  * dns_query - Query the DNS
  * @type: Query type (or NULL for straight host->IP lookup)
  * @name: Name to look up


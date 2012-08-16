Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717Ab2HPBi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:38:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675Ab2HPBiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:38:55 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/25] MODSIGN: Fix documentation of signed-nokey behavior
 when not enforcing.
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:38:45 +0100
Message-ID: <20120816013845.872.74533.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jwboyer's previous commit changes the behavior of module signing when
there's a valid signature but we don't know the public key and are in
permissive mode.  This updates the documentation to match.

Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/module-signing.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
index b355aa2..2549536 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -174,7 +174,7 @@ This table indicates the behaviours of the various situations:
 	MODULE STATE				PERMISSIVE MODE	ENFORCING MODE
 	=======================================	===============	===============
 	Unsigned				Ok		EKEYREJECTED
-	Signed, no public key			ENOKEY		ENOKEY
+	Signed, no public key			Ok		ENOKEY
 	Validly signed, public key		Ok		Ok
 	Invalidly signed, public key		EKEYREJECTED	EKEYREJECTED
 	Validly signed, expired key		EKEYEXPIRED	EKEYEXPIRED


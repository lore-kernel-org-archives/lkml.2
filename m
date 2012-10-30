Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab2J3TUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756517Ab2J3TUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:20:40 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 06/23] x509: struct x509_certificate needs struct tm declaring
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, pjones@redhat.com, jwboyer@redhat.com, mjg@redhat.com,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        keescook@chromium.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 30 Oct 2012 19:20:23 +0000
Message-ID: <20121030192023.11000.7971.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
References: <20121030191927.11000.68420.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct x509_certificate needs struct tm declaring by #inclusion of linux/time.h
prior to its definition.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/x509_parser.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index e583ad0..2d01182 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/time.h>
 #include <crypto/public_key.h>
 
 struct x509_certificate {


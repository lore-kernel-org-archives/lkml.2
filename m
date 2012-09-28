Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2I1GHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:07:25 -0400
Received: from ozlabs.org ([203.10.76.45]:43788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab2I1GHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:07:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: [PATCH 1/2] modsign: don't use bashism in sh scripts.
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 28 Sep 2012 15:28:23 +0930
Message-ID: <87obkq3czk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/sign-file b/scripts/sign-file
index 1a472bb..e58e34e 100644
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -10,7 +10,7 @@ scripts=`dirname $0`
 CONFIG_MODULE_SIG_SHA512=y
 if [ -r .config ]
 then
-    source ./.config
+    . ./.config
 fi
 
 key="$1"

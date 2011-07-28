Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1G1P4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab1G1Pz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:55:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 38/40] UAPI: Fix the page-types query program in the docs [ver
 #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:55:23 +0100
Message-ID: <20110728155523.16618.65767.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the page-types query program in Documentation/vm/ as that refers to the
magic numbers header file directly, but the magic numbers are now in the UAPI
headers.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/vm/page-types.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
index 7445caa..8d6a54f 100644
--- a/Documentation/vm/page-types.c
+++ b/Documentation/vm/page-types.c
@@ -34,7 +34,7 @@
 #include <sys/fcntl.h>
 #include <sys/mount.h>
 #include <sys/statfs.h>
-#include "../../include/linux/magic.h"
+#include "../../include/uapi/linux/magic.h"
 
 
 #ifndef MAX_PATH


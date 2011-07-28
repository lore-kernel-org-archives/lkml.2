Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab1G1Pxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab1G1Pxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:53:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/40] UAPI: sound/sound_core.c should include linux/fs.h [ver
 #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:53:02 +0100
Message-ID: <20110728155302.16618.93625.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/sound_core.c should include linux/fs.h to get the definition of struct
file_operations.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 sound/sound_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 6ce2778..b6bc127 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/kdev_t.h>
 #include <linux/major.h>
+#include <linux/fs.h>
 #include <sound/core.h>
 
 #ifdef CONFIG_SOUND_OSS_CORE


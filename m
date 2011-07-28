Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab1G1PyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:54:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab1G1PyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:54:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 28/40] UAPI: Guard linux/sound.h [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:53:46 +0100
Message-ID: <20110728155346.16618.86248.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place reinclusion guards on linux/sound.h otherwise the splitter script won't
insert the UAPI #include.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/sound.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/sound.h b/include/linux/sound.h
index 44dcf05..fae20ba 100644
--- a/include/linux/sound.h
+++ b/include/linux/sound.h
@@ -1,3 +1,5 @@
+#ifndef _LINUX_SOUND_H
+#define _LINUX_SOUND_H
 
 /*
  * Minor numbers for the sound driver.
@@ -42,3 +44,5 @@ extern void unregister_sound_mixer(int unit);
 extern void unregister_sound_midi(int unit);
 extern void unregister_sound_dsp(int unit);
 #endif /* __KERNEL__ */
+
+#endif /* _LINUX_SOUND_H */


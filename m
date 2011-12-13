Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab1LMKje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:39:34 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52116 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab1LMKjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:39:31 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 08/17] UAPI: Guard linux/sound.h
Date: Tue, 13 Dec 2011 10:04:04 +0000
Message-Id: <1323770653-19177-9-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place reinclusion guards on linux/sound.h otherwise the UAPI splitter script
won't insert a #include to make the kernel header include the UAPI header.

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
-- 
1.7.7.4


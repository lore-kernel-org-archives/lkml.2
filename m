Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab0KXRYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 12:24:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56383 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755988Ab0KXRYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 12:24:03 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18yS5MIhJgyB1VFbHcC5T2b0bj54gOoc7UdBmbnw4
	ip0k8cQsl7v8E2
Date: Wed, 24 Nov 2010 18:22:09 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] fanotify: Introduce FAN_NOFD
Message-ID: <20101124172209.GB18135@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FAN_NOFD is used in fanotify events that do not provide an open file
descriptor (like the overflow_event).

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
---
 include/linux/fanotify.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Please apply this against commit 9df291342d1330d4d2ddf389820f58dda975f8dd
of branch 'origin/for-next' from git.infradead.org/users/eparis/notify.git

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 3db66ef..d6ec57a 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -104,6 +104,8 @@ struct fanotify_response {
 /* Legit userspace responses to a _PERM event */
 #define FAN_ALLOW	0x01
 #define FAN_DENY	0x02
+/* No fd set in event */
+#define FAN_NOFD	-1
 
 /* Helper functions to deal with fanotify_event_metadata buffers */
 #define FAN_EVENT_METADATA_LEN (sizeof(struct fanotify_event_metadata))
-- 
1.5.6.5


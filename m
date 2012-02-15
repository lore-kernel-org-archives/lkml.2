Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942Ab2BOK6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:58:47 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58530 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab2BOK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:58:46 -0500
MIME-Version: 1.0
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@dowhile0.org>
Subject: [PATCH 1/1][trivial] security: Trivial struct security_operations documentation fix
Date: Wed, 15 Feb 2012 11:58:54 +0100
Message-Id: <1329303534-3194-1-git-send-email-javier@dowhile0.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unix_may_send hook has the prototype:

int (*unix_may_send) (struct socket *sock, struct socket *other)

so the documentation is wrongly referring to the second argument as @sock.

Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
---
 include/linux/security.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 83c18e8..c894938 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -812,7 +812,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Check permissions before connecting or sending datagrams from @sock to
  *	@other.
  *	@sock contains the socket structure.
- *	@sock contains the peer socket structure.
+ *	@other contains the peer socket structure.
  *	Return 0 if permission is granted.
  *
  * The @unix_stream_connect and @unix_may_send hooks were necessary because
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1EAMhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 08:37:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56781 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1EAMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 08:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ut0ydXl+DVQM+S4yGy2fpYRuWNbfg+ktO6w9rWuCyb4UzrtRclMSQhugsv2WyJ7O1i
         JWHFoj0O5d89APiwzkjh59Mm19/Z5uZKG//ChC8+1uUWlgXvPqRJJnB2dq0oJxKjfBQ8
         4w/PhjoebqKB/hPqo4WhHsWpK2CF+FndTtqXA=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Adrian Bunk <bunk@kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] MAINTAINERS: remove stale reference to Chris Wright's LSM tree
Date: Sun,  1 May 2011 14:37:10 +0200
Message-Id: <1304253430-5513-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick glance at [1] will show that the tree hasn't been updated
since June 2008 => No need to have a reference to it.

[1] http://git.kernel.org/?p=linux/kernel/git/chrisw/lsm-2.6.git;a=summary

This patch was first sent in Feb 2011, but no one cared about it then.

I fount no maintainer for the MAINTAINERS file :)

Adrian: I'm sending this to you as you seem to be the designated Trivial Patch Monkey.
http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/

Cc: Adrian Bunk <bunk@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>

Acked-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1380312..d7fbac3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3890,7 +3890,6 @@ F:	drivers/*/*/*pasemi*
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LIS3LV02D ACCELEROMETER DRIVER
-- 
1.7.5.134.g1c08b


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1BAXvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 18:51:52 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58865 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab1BAXvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 18:51:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=r4dkeL/kPOpCJC4VtTVYTgxjeF3mO7RnonejgTOsPfmukSAOT8+YRwFMVvnXJDI/W5
         aVlD++QBNj3AJEBn7O3DPSfHKwjW0nhjRgd2ZdXhOQTG+uP93OKWOfHYIBR8gwHHMCvH
         4tZzpSIhw2zp1W1Yf0nAmNoGddP2NEnQz091w=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH] MAINTAINERS: remove stale reference to Chris Wright's LSM tree
Date: Wed,  2 Feb 2011 01:51:39 +0200
Message-Id: <1296604299-20620-1-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.4.rc1.7.g2cf08.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A quick glance at [1] will show that the tree hasn't been updated
since June 2008 => No need to have a reference to it.

[1] http://git.kernel.org/?p=linux/kernel/git/chrisw/lsm-2.6.git;a=summary

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 445537d..0a4b0ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3866,7 +3866,6 @@ F:	drivers/*/*/*pasemi*
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git
 S:	Supported
 
 LLC (802.2)
-- 
1.7.4.rc1.7.g2cf08.dirty


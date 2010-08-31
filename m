Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab0HaPI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:08:58 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:52643 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab0HaPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:08:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com, joe@perches.com
Subject: [PATCH 1/1] MAINTAINERS: orphan isicom
Date: Tue, 31 Aug 2010 17:08:52 +0200
Message-Id: <1283267332-20879-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283267024.1797.22.camel@Joe-Laptop>
References: <1283267024.1797.22.camel@Joe-Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I do not maintain isicom anymore...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e24eb2d..8313ce3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3924,8 +3924,7 @@ F:	Documentation/sound/oss/MultiSound
 F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
-M:	Jiri Slaby <jirislaby@gmail.com>
-S:	Maintained
+S:	Orphan
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
 
-- 
1.7.2.2



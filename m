Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0IDCNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:13:33 -0400
Received: from kroah.org ([198.145.64.141]:48229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0IDCNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:13:31 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] MAINTAINERS: orphan isicom
Date: Fri,  3 Sep 2010 19:13:19 -0700
Message-Id: <1283566402-28832-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100904020937.GA28645@kroah.com>
References: <20100904020937.GA28645@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

I do not maintain isicom anymore...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c36f5d7..c5afc93d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3923,8 +3923,7 @@ F:	Documentation/sound/oss/MultiSound
 F:	sound/oss/msnd*
 
 MULTITECH MULTIPORT CARD (ISICOM)
-M:	Jiri Slaby <jirislaby@gmail.com>
-S:	Maintained
+S:	Orphan
 F:	drivers/char/isicom.c
 F:	include/linux/isicom.h
 
-- 
1.7.2


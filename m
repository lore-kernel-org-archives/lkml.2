Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0JVSZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:34 -0400
Received: from kroah.org ([198.145.64.141]:37777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932Ab0JVSZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/31] debugfs: mark me as the maintainer
Date: Fri, 22 Oct 2010 11:24:54 -0700
Message-Id: <1287771916-15016-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DEBUGFS information to my MAINTAINERS entry as some people have
asked about this recently.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f2a2b8e..22aa094 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2050,14 +2050,16 @@ F:	drivers/block/drbd/
 F:	lib/lru_cache.c
 F:	Documentation/blockdev/drbd/
 
-DRIVER CORE, KOBJECTS, AND SYSFS
+DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@suse.de>
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
 F:	Documentation/kobject.txt
 F:	drivers/base/
 F:	fs/sysfs/
+F:	fs/debugfs/
 F:	include/linux/kobj*
+F:	include/linux/debugfs.h
 F:	lib/kobj*
 
 DRM DRIVERS
-- 
1.7.2


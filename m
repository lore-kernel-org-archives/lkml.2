Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0LBVH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:07:28 -0500
Received: from kroah.org ([198.145.64.141]:54181 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab0LBVH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:07:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/3] driver core: the development tree has switched to git
Date: Thu,  2 Dec 2010 13:07:22 -0800
Message-Id: <1291324044-6716-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202205212.GA6130@kroah.com>
References: <20101202205212.GA6130@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So change the MAINTAINERS file to show where the tree now is at.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0094224..283d5f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2051,7 +2051,7 @@ F:	Documentation/blockdev/drbd/
 
 DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS
 M:	Greg Kroah-Hartman <gregkh@suse.de>
-T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git
 S:	Supported
 F:	Documentation/kobject.txt
 F:	drivers/base/
-- 
1.7.1


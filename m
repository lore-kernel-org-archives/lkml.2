Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab1EKVGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:06:42 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914Ab1EKVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:41 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/16] add maintainers entry for C6X arch
Date: Wed, 11 May 2011 16:13:53 -0400
Message-Id: <1305144843-5058-7-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-6-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16a5c5f..4da0c6d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1601,6 +1601,17 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/pci/oxygen/
 
+C6X ARCHITECTURE
+M:	Mark Salter <msalter@redhat.com>
+M:	Aurelien Jacquiot <a-jacquiot@ti.com>
+L:	linux-c6x-dev@linux-c6x.org
+W:	http://www.linux-c6x.org/wiki/index.php/Main_Page
+S:	Maintained
+F:	arch/c6x/
+F:	drivers/net/c6x_*
+F:	drivers/platforms/c6x/
+F:	drivers/tty/hvc/hvc_c6x.c
+
 CACHEFILES: FS-CACHE BACKEND FOR CACHING ON MOUNTED FILESYSTEMS
 M:	David Howells <dhowells@redhat.com>
 L:	linux-cachefs@redhat.com
-- 
1.6.2.5


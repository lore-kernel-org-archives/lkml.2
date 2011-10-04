Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1JDQps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924Ab1JDQob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:31 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: [PATCH v4 24/24] C6X: MAINTAINERS
Date: Tue,  4 Oct 2011 12:44:01 -0400
Message-Id: <1317746641-26725-25-git-send-email-msalter@redhat.com>
In-Reply-To: <1317746641-26725-1-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cfc062e..ccc9eba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1650,6 +1650,14 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/pci/oxygen/
 
+C6X ARCHITECTURE
+M:	Mark Salter <msalter@redhat.com>
+M:	Aurelien Jacquiot <a-jacquiot@ti.com>
+L:	linux-c6x-dev@linux-c6x.org
+W:	http://www.linux-c6x.org/wiki/index.php/Main_Page
+S:	Maintained
+F:	arch/c6x/
+
 CACHEFILES: FS-CACHE BACKEND FOR CACHING ON MOUNTED FILESYSTEMS
 M:	David Howells <dhowells@redhat.com>
 L:	linux-cachefs@redhat.com
-- 
1.7.6.2


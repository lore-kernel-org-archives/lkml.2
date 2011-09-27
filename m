Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1I0Uan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:30:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab1I0Uae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:30:34 -0400
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Mark Salter <msalter@redhat.com>
Subject: [PATCH v3 24/24] C6X: MAINTAINERS
Date: Tue, 27 Sep 2011 16:30:05 -0400
Message-Id: <1317155405-26235-25-git-send-email-msalter@redhat.com>
In-Reply-To: <1317155405-26235-1-git-send-email-msalter@redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28f65c2..adc3e81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1626,6 +1626,14 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
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


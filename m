Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab2KXA1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:21 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:39749 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab2KXA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:19 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org
Subject: [PATCH 06/24] MAINTAINERS: fix drivers/media/platform/atmel-isi.c
Date: Fri, 23 Nov 2012 22:26:30 -0200
Message-Id: <1353716808-16375-7-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file was moved to drivers/media/platform/soc_camera/atmel-isi.c by
commit b47ff4a ([media] move soc_camera to its own directory).

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd28c70..05054ad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1395,7 +1395,7 @@ ATMEL ISI DRIVER
 M:	Josh Wu <josh.wu@atmel.com>
 L:	linux-media@vger.kernel.org
 S:	Supported
-F:	drivers/media/platform/atmel-isi.c
+F:	drivers/media/platform/soc_camera/atmel-isi.c
 F:	include/media/atmel-isi.h
 
 ATMEL LCDFB DRIVER
-- 
1.7.11.7


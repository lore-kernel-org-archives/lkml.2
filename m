Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab0FFMGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 08:06:04 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50809 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab0FFMGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 08:06:00 -0400
X-Authority-Analysis: v=1.1 cv=q7FD15Xr545AYYxLuRxh8NAlF1RX961CvM641wXl56g= c=1 sm=0 a=8Q1xMX3U-tIA:10 a=UBIxAjGgU1YA:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=hGzw-44bAAAA:8 a=voM4FWlXAAAA:8 a=IvMY5PC-p0XlhHZX5CkA:9 a=In6L4ABhp1xCnA2wwumVCezq6JIA:4 a=jEp0ucaQiEUA:10 a=dowx1zmaLagA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-cifs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: change mailing list address for CIFS
Date: Sun,  6 Jun 2010 08:05:58 -0400
Message-Id: <1275825958-20974-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're moving the mailing list to linux-cifs@vger.kernel.org.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 67accd7..5ddf896 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1581,7 +1581,7 @@ F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 M:	Steve French <sfrench@samba.org>
-L:	linux-cifs-client@lists.samba.org (moderated for non-subscribers)
+L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 W:	http://linux-cifs.samba.org/
 Q:	http://patchwork.ozlabs.org/project/linux-cifs-client/list/
-- 
1.6.6.1


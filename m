Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2CSQAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:00:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37845 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab2CSQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:00:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dan.magenheimer@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] MAINTAINERS: Adding cleancache API to the list.
Date: Mon, 19 Mar 2012 11:49:25 -0400
Message-Id: <1332172165-4362-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1332172165-4362-1-git-send-email-konrad.wilk@oracle.com>
References: <1332172165-4362-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F675825.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. and electing myself as the maintainer.

CC: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c63a43..e1a70cb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1831,6 +1831,13 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 
+CLEANCACHE API
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	mm/cleancache.c
+F:	include/linux/cleancache.h
+
 CLK API
 M:	Russell King <linux@arm.linux.org.uk>
 F:	include/linux/clk.h
-- 
1.7.7.5


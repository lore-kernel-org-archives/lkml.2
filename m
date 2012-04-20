Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2DTVtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:49:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:28785 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab2DTVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:49:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ngupta@vflare.org,
        sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        aarcange@redhat.com, dhowells@redhat.com, riel@redhat.com,
        JBeulich@novell.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 5/6] MAINTAINER: Add myself for the frontswap API
Date: Fri, 20 Apr 2012 17:44:14 -0400
Message-Id: <1334958255-6612-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334958255-6612-1-git-send-email-konrad.wilk@oracle.com>
References: <1334958255-6612-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F91D9E0.0037,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2dcfca8..bc8905d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2876,6 +2876,13 @@ F:	Documentation/power/freezing-of-tasks.txt
 F:	include/linux/freezer.h
 F:	kernel/freezer.c
 
+FRONTSWAP API
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	mm/frontswap.c
+F:	include/linux/frontswap.h
+
 FS-CACHE: LOCAL CACHING FOR NETWORK FILESYSTEMS
 M:	David Howells <dhowells@redhat.com>
 L:	linux-cachefs@redhat.com
-- 
1.7.7.5


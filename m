Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1JXNx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:53:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44793 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1JXNx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:53:26 -0400
Message-ID: <4EA56D60.2030208@oracle.com>
Date: Mon, 24 Oct 2011 21:51:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
Reply-To: jeff.liu@oracle.com
Organization: Oracle
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk
Subject: [PATCH] Fix a typo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EA56DCD.007B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 block/blk-cgroup.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index a71d290..6f3ace7 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -188,7 +188,7 @@ struct blkio_policy_node {
 	union {
 		unsigned int weight;
 		/*
-		 * Rate read/write in terms of byptes per second
+		 * Rate read/write in terms of bytes per second
 		 * Whether this rate represents read or write is determined
 		 * by file type "fileid".
 		 */
-- 
1.7.4.1

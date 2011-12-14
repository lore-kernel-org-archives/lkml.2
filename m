Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab1LNLtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 06:49:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51439 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab1LNLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 06:49:30 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Mark Grosen <mgrosen@ti.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 3/7] remoteproc: remove unused resource type
Date: Wed, 14 Dec 2011 13:48:31 +0200
Message-Id: <1323863315-8159-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323863315-8159-1-git-send-email-ohad@wizery.com>
References: <1323863315-8159-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RSC_VIRTIO_CFG isn't being used, so remove it.

Originally it was introduced to overcome a resource table limitation
that prevented describing a virtio device in a single resource table
entry.

The plan though is to describe resource table entries in a TLV fashion,
where each entry will consume the amount of space it requires,
so the original limitation is anyway temporary.

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 include/linux/remoteproc.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 1edbfde..b52f784 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -122,7 +122,6 @@ enum fw_resource_type {
 	RSC_TRACE	= 2,
 	RSC_VRING	= 3,
 	RSC_VIRTIO_DEV	= 4,
-	RSC_VIRTIO_CFG	= 5,
 };
 
 /**
-- 
1.7.5.4


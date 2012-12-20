Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab2LTTMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:12:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20781 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2LTTMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:12:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] kvm tools: correctly compare pointer with NULL instead of 0
Date: Thu, 20 Dec 2012 14:11:12 -0500
Message-Id: <1356030701-16284-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/kvm/hw/pci-shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/hw/pci-shmem.c b/tools/kvm/hw/pci-shmem.c
index 00e5d93..ec3f771 100644
--- a/tools/kvm/hw/pci-shmem.c
+++ b/tools/kvm/hw/pci-shmem.c
@@ -356,7 +356,7 @@ int pci_shmem__init(struct kvm *kvm)
 	char *mem;
 	int r;
 
-	if (shmem_region == 0)
+	if (shmem_region == NULL)
 		return 0;
 
 	/* Register good old INTx */
-- 
1.8.0


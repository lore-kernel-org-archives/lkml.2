Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1EDST5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:19:57 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:52851 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983Ab1EDST4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:19:56 -0400
Date: Wed, 4 May 2011 20:19:49 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH 8/8] drivers/xen/sys-hypervisor: Cleanup code/data sections definitions
Message-ID: <20110504181949.GI29218@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup code/data sections definitions
accordingly to include/linux/init.h.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 drivers/xen/sys-hypervisor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 60f1827..1e0fe01 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -215,7 +215,7 @@ static struct attribute_group xen_compilation_group = {
 	.attrs = xen_compile_attrs,
 };
 
-int __init static xen_compilation_init(void)
+static int __init xen_compilation_init(void)
 {
 	return sysfs_create_group(hypervisor_kobj, &xen_compilation_group);
 }
-- 
1.5.6.5

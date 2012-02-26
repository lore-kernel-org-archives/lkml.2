Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2BZWx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:53:58 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22086 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2BZWx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:53:57 -0500
Date: Sun, 26 Feb 2012 23:51:53 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, dri-devel@lists.freedesktop.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: [PATCH][trivial] radeon: remove redundant ';' from
 radeon_vm_bo_update_pte()
Message-ID: <alpine.LNX.2.00.1202262348240.6089@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return statement needs just one semi-colon

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/radeon/radeon_gart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 010dad8..d5b1adc 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -551,7 +551,7 @@ int radeon_vm_bo_update_pte(struct radeon_device *rdev,
 
 	/* nothing to do if vm isn't bound */
 	if (vm->id == -1)
-		return 0;;
+		return 0;
 
 	bo_va = radeon_bo_va(bo, vm);
 	if (bo_va == NULL) {
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.


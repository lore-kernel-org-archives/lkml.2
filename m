Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030569Ab2HXWQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:16:46 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37646 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760224Ab2HXWQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:16:39 -0400
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH drm-next 2/3] drm/i915: Remove reference to drm_display_info raw_edid field
Date: Sat, 25 Aug 2012 00:16:23 +0200
Message-Id: <1345846584-5910-2-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
References: <1345846584-5910-1-git-send-email-sedat.dilek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-By: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 drivers/gpu/drm/i915/intel_modes.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index 29b7259..4bc1c0f 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -45,7 +45,6 @@ int intel_connector_update_modes(struct drm_connector *connector,
 	drm_mode_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
 	drm_edid_to_eld(connector, edid);
-	connector->display_info.raw_edid = NULL;
 	kfree(edid);
 
 	return ret;
-- 
1.7.9.5


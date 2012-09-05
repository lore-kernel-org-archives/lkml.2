Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629Ab2IEVsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 17:48:03 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44323 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072Ab2IEVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 17:48:01 -0400
From: Emil Goode <emilgoode@gmail.com>
To: airlied@linux.ie, airlied@redhat.com, alan@linux.intel.com,
        patrik.r.jakobsson@gmail.com, yakui.zhao@intel.com,
        jani.nikula@intel.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] gma500: Remove unused variable
Date: Wed,  5 Sep 2012 23:51:47 +0200
Message-Id: <1346881907-5596-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a unused struct psb_intel_connector

Sparse gives a warning:
drivers/gpu/drm/gma500/cdv_intel_hdmi.c:142:30: warning:
	unused variable ‘psb_intel_connector’ [-Wunused-variable]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
index b1b77bb..7272a46 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
@@ -139,8 +139,6 @@ static enum drm_connector_status cdv_hdmi_detect(
 {
 	struct psb_intel_encoder *psb_intel_encoder =
 					psb_intel_attached_encoder(connector);
-	struct psb_intel_connector *psb_intel_connector =
-					to_psb_intel_connector(connector);
 	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_encoder->dev_priv;
 	struct edid *edid = NULL;
 	enum drm_connector_status status = connector_status_disconnected;
-- 
1.7.10.4


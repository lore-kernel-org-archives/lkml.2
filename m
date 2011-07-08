Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab1GHIyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:54:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40024 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab1GHIyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:54:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/12] gma500: Fix unused variable in cdv support
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 08 Jul 2011 09:45:07 +0100
Message-ID: <20110708084503.19581.67808.stgit@localhost.localdomain>
In-Reply-To: <20110708084053.19581.81711.stgit@localhost.localdomain>
References: <20110708084053.19581.81711.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/cdv_intel_hdmi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/gma500/cdv_intel_hdmi.c b/drivers/staging/gma500/cdv_intel_hdmi.c
index 7f86c0c..cbca2b0 100644
--- a/drivers/staging/gma500/cdv_intel_hdmi.c
+++ b/drivers/staging/gma500/cdv_intel_hdmi.c
@@ -133,7 +133,6 @@ static void cdv_hdmi_restore(struct drm_connector *connector)
 static enum drm_connector_status cdv_hdmi_detect(
 				struct drm_connector *connector, bool force)
 {
-	struct drm_device *dev = connector->dev;
 	struct psb_intel_output *psb_intel_output =
 						to_psb_intel_output(connector);
 	struct mid_intel_hdmi_priv *hdmi_priv = psb_intel_output->dev_priv;


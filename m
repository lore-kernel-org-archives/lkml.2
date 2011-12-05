Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab1LFAAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:00:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16909 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab1LEX7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:59:23 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 05 Dec 2011 15:59:19 -0800
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 3/5] Adding entry for Smart Battery Systems
Date: Mon,  5 Dec 2011 15:58:05 -0800
Message-Id: <1323129487-24859-3-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
References: <1323129487-24859-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2c1b2cb..334c548 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -32,6 +32,7 @@ powervr	Imagination Technologies
 qcom	Qualcomm, Inc.
 ramtron	Ramtron International
 samsung	Samsung Semiconductor
+sbs	Smart Battery System
 schindler	Schindler
 simtek
 sirf	SiRF Technology, Inc.
-- 
1.7.0.4


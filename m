Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2F2KpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 06:45:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46834 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab2F2KpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 06:45:01 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] usage-model.txt: fix typo machine_init->init_machine
Date: Fri, 29 Jun 2012 12:44:46 +0200
Message-Id: <1340966686-26430-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

machine_init was used intead of init_machine which clearly was not
intended.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 Documentation/devicetree/usage-model.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/usage-model.txt b/Documentation/devicetree/usage-model.txt
index c5a8009..dca90fe 100644
--- a/Documentation/devicetree/usage-model.txt
+++ b/Documentation/devicetree/usage-model.txt
@@ -312,7 +312,7 @@ device tree for the NVIDIA Tegra board.
 	};
 };
 
-At .machine_init() time, Tegra board support code will need to look at
+At .init_machine() time, Tegra board support code will need to look at
 this DT and decide which nodes to create platform_devices for.
 However, looking at the tree, it is not immediately obvious what kind
 of device each node represents, or even if a node represents a device
-- 
1.7.2.5


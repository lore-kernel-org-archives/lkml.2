Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab1E3ECc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 00:02:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59756 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1E3ECb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 00:02:31 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bhaskar Upadhaya <bhaskar.upadhaya@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] powerpc: drop +x perms on text file
Date: Mon, 30 May 2011 00:07:29 -0400
Message-Id: <1306728449-16812-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
old mode 100755
new mode 100644
-- 
1.7.5.rc3


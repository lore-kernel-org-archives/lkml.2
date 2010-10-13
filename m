Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0JMJbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:31:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51744 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab0JMJbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:31:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/4] EDAC, MCE: Add F12h IC MCE decoder
Date: Wed, 13 Oct 2010 11:31:38 +0200
Message-Id: <1286962300-23385-3-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286962300-23385-1-git-send-email-bp@amd64.org>
References: <1286962300-23385-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

... which is the same as for K8 and F10h.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 1f895df..fc3712f 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -640,6 +640,7 @@ static int __init mce_amd_init(void)
 
 	case 0x12:
 		fam_ops->dc_mce = f12h_dc_mce;
+		fam_ops->ic_mce = k8_ic_mce;
 		break;
 
 	case 0x14:
-- 
1.7.3.1.50.g1e633


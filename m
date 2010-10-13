Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab0JMJbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:31:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51760 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0JMJbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:31:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 4/4] EDAC, MCE: Enable MCE decoding on F12h
Date: Wed, 13 Oct 2010 11:31:40 +0200
Message-Id: <1286962300-23385-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286962300-23385-1-git-send-email-bp@amd64.org>
References: <1286962300-23385-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Turn on MCE decoding on F12h.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 6501392..7f74f0f 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -611,7 +611,7 @@ static int __init mce_amd_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return 0;
 
-	if ((boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11) &&
+	if ((boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x12) &&
 	    (boot_cpu_data.x86 != 0x14 || boot_cpu_data.x86_model > 0xf))
 		return 0;
 
-- 
1.7.3.1.50.g1e633


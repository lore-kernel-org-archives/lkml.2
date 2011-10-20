Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab1JTVxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:53:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab1JTVxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:53:05 -0400
Date: Thu, 20 Oct 2011 19:52:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] edac: tag sb_edac as EXPERIMENTAL, as it requires more
 testing
Message-ID: <20111020195234.54fbbf2b@redhat.com>
In-Reply-To: <cover.1319146957.git.mchehab@redhat.com>
References: <cover.1319146957.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index d9d40d4..7769a24 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -215,6 +215,7 @@ config EDAC_I7300
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
 	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
+	depends on EXPERIMENTAL
 	help
 	  Support for error detection and correction the Intel
 	  Sandy Bridge Integrated Memory Controller.
-- 
1.7.6.4


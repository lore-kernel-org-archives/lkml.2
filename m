Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1JLNJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:09:28 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:54710 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab1JLNJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:09:27 -0400
Subject: [PATCH] Drop default from "DM365 codec select" choice
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 15:09:22 +0200
Message-ID: <1318424962.2336.22.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SND_DM365_EXTERNAL_CODEC does not exist, so it's a useless default.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Testing this with "make ARCH=arm menuconfig" (and enabling a number of
dependencies) this "choice" still defaults to the first option (as
choices apparently do when no default is specified).

 sound/soc/davinci/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index 6bbf001..9e11a14 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -29,7 +29,6 @@ choice
 	prompt "DM365 codec select"
 	depends on SND_DAVINCI_SOC_EVM
 	depends on MACH_DAVINCI_DM365_EVM
-	default SND_DM365_EXTERNAL_CODEC
 
 config SND_DM365_AIC3X_CODEC
 	bool "Audio Codec - AIC3101"
-- 
1.7.4.4




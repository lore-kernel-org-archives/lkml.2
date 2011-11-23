Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1KWKoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:44:30 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:47478 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab1KWKo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:44:28 -0500
Message-ID: <1322045064.1753.51.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] gpio: Kconfig: drop unknown symbol 'CS5535_GPIO'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 11:44:24 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit af0c25c487 ("staging: remove obsoleted CS5535/CS5536 GPIO
driver") dropped CS5535_GPIO. So this last reference to CS5535_GPIO has
been an (inconsequential) nop since v3.1. Drop it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/gpio/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 8482a23..8b40b38 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -356,7 +356,7 @@ comment "PCI GPIO expanders:"
 
 config GPIO_CS5535
 	tristate "AMD CS5535/CS5536 GPIO support"
-	depends on PCI && X86 && !CS5535_GPIO && MFD_CS5535
+	depends on PCI && X86 && MFD_CS5535
 	help
 	  The AMD CS5535 and CS5536 southbridges support 28 GPIO pins that
 	  can be used for quite a number of things.  The CS5535/6 is found on
-- 
1.7.7.3




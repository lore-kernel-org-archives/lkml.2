Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1JLMkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:40:05 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:38730 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1JLMkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:40:04 -0400
Subject: [PATCH] [TRIVIAL] tty: drop superfluous dependency in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 14:40:02 +0200
Message-ID: <1318423202.2336.16.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW_CONSOLE doesn't need to depend on both VT and !S390 as VT already
depends on !S390.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Nothing changed when testing this with "make ARCH=s390 menuconfig",
which is good.

 drivers/tty/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/Kconfig b/drivers/tty/Kconfig
index bd7cc05..f462fa5 100644
--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -62,7 +62,7 @@ config VT_CONSOLE
 
 config HW_CONSOLE
 	bool
-	depends on VT && !S390 && !UML
+	depends on VT && !UML
 	default y
 
 config VT_HW_CONSOLE_BINDING
-- 
1.7.4.4




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1KMAna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:43:30 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:43520 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1KMAn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:43:29 -0500
Subject: [PATCH] [TRIVIAL] unicore32: Fix typo 'PUV3_I2C'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 01:43:23 +0100
Message-ID: <1321145003.20271.36.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) This corrects an obvious typo. It is untested.

1) This could influence the code generated for "I2C Battery BQ27200
Support" and for "I2C EEPROMs AT24 support". So I've CC'd the people
involved in commit fa7499ef77 ("unicore32 machine related files: core
files"), which introduced this typo, to actually test this.

 arch/unicore32/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index e57dcce..942ed61 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -237,13 +237,13 @@ menu "PKUnity NetBook-0916 Features"
 
 config I2C_BATTERY_BQ27200
 	tristate "I2C Battery BQ27200 Support"
-	select PUV3_I2C
+	select I2C_PUV3
 	select POWER_SUPPLY
 	select BATTERY_BQ27x00
 
 config I2C_EEPROM_AT24
 	tristate "I2C EEPROMs AT24 support"
-	select PUV3_I2C
+	select I2C_PUV3
 	select MISC_DEVICES
 	select EEPROM_AT24
 
-- 
1.7.4.4




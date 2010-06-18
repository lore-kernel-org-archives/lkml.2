Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264Ab0FRQIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 12:08:32 -0400
Received: from imr3.ericy.com ([198.24.6.13]:41128 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab0FRQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 12:08:30 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Hans de Goede <hdegoede@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org,
       Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 3/3] hwmon: Update MAINTAINERS for smm665 driver
Date: Fri, 18 Jun 2010 09:06:34 -0700
Message-ID: <1276877194-28214-4-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
References: <1276877194-28214-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..2e8334d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5205,6 +5205,13 @@ M:	Nicolas Pitre <nico@fluxnic.net>
 S:	Odd Fixes
 F:	drivers/net/smc91x.*
 
+SMM665 HARDWARE MONITOR DRIVER
+M:	"Guenter Roeck" <linux@roeck-us.net>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	Documentation/hwmon/smm665
+F:	drivers/hwmon/smm665.c
+
 SMSC47B397 HARDWARE MONITOR DRIVER
 M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
 L:	lm-sensors@lm-sensors.org
-- 
1.7.0.87.g0901d


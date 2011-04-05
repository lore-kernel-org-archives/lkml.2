Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab1DEViW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 17:38:22 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45620 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab1DEViR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 17:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HkHFpuJu7Tn+E4z239KHxmQ+IU1bwkuFSw8PXrwcqOUL1qrtCOv+1u7cYm5kzUrcGF
         l79TnA+0pqxLnsVkPDcFZWFfnUU8GHZe7RWjpgG3hcZ21wKx3MoriTYbcftOD5d04843
         zLOKnqLnfOwM0uMaNaj1ie0m4dsJbIBCgYluo=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: davinci-linux-open-source@linux.davincidsp.com, linux-i2c@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        Brad Griffis <bgriffis@ti.com>, Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>,
        Ben Gardiner <bengardiner@nanometrics.ca>,
        Sekhar Nori <nsekhar@ti.com>, Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 2/6] i2c-davinci: convert davinci_i2c_platform_data to kerneldoc
Date: Tue,  5 Apr 2011 17:38:05 -0400
Message-Id: <0710b48a8514dface179b54c615b7cc0bba20d42.1302031487.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1302031487.git.bengardiner@nanometrics.ca>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The davinci_i2c_platform_data struct is mach-specific but still deserves
to be documented using kernel doc.

Signed-off-by: Ben Gardiner<bengardiner@nanometrics.ca>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Ben Dooks <ben-linux@fluff.org>

---
 arch/arm/mach-davinci/include/mach/i2c.h |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/arch/arm/mach-davinci/include/mach/i2c.h
index 2312d19..ab07a44 100644
--- a/arch/arm/mach-davinci/include/mach/i2c.h
+++ b/arch/arm/mach-davinci/include/mach/i2c.h
@@ -12,12 +12,19 @@
 #ifndef __ASM_ARCH_I2C_H
 #define __ASM_ARCH_I2C_H
 
-/* All frequencies are expressed in kHz */
+/**
+ * davinci_i2c_platform_data - Platform data for I2C master device on DaVinci
+ *
+ * @bus_freq:	standard bus frequency (kHz)
+ * @bus_delay:	post-transaction delay (usec)
+ * @sda_pin:	GPIO pin ID to use for SDA
+ * @scl_pin:	GPIO pin ID to use for SCL
+ */
 struct davinci_i2c_platform_data {
-	unsigned int	bus_freq;	/* standard bus frequency (kHz) */
-	unsigned int	bus_delay;	/* post-transaction delay (usec) */
-	unsigned int    sda_pin;        /* GPIO pin ID to use for SDA */
-	unsigned int    scl_pin;        /* GPIO pin ID to use for SCL */
+	unsigned int	bus_freq;
+	unsigned int	bus_delay;
+	unsigned int	sda_pin;
+	unsigned int	scl_pin;
 };
 
 /* for board setup code */
-- 
1.7.1


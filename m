Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab0LIVv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:51:57 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:59744 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757451Ab0LIVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:51:27 -0500
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Chris Cordahi <christophercordahi@nanometrics.ca>,
        Paul Mundt <lethal@linux-sh.org>, Sekhar Nori <nsekhar@ti.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH v6 5/5] da850-evm: KEYBOARD_GPIO_POLLED Kconfig conditional
Date: Thu,  9 Dec 2010 16:51:07 -0500
Message-Id: <939e12134ad83efb7a8706d16afec7c12663079e.1291931041.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1291931041.git.bengardiner@nanometrics.ca>
References: <cover.1290635422.git.bengardiner@nanometrics.ca> <cover.1291931041.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the mach-davinci/Kconfig to enable gpio-keys-polled as default when
da850-evm machine is enabled.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: "Nori, Sekhar" <nsekhar@ti.com>
CC: Gabor Juhos <juhosg@openwrt.org>

---

Changes since v5:
 * no changes in this patch of the series

Changes since v4:
 * integrated the use of Gabor Juhos' polled gpio buttons driver

Changes since v3:
 * no changes in this patch of the series / this patch was introduced in v4 of
   the series
---
 arch/arm/mach-davinci/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 84066e8..b93c327 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -180,6 +180,9 @@ endchoice
 config GPIO_PCA953X
 	default MACH_DAVINCI_DA850_EVM
 
+config KEYBOARD_GPIO_POLLED
+	default MACH_DAVINCI_DA850_EVM
+
 config MACH_TNETV107X
 	bool "TI TNETV107X Reference Platform"
 	default ARCH_DAVINCI_TNETV107X
-- 
1.7.0.4


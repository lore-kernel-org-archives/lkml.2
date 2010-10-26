Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab0JZT5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39482 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/22] trivial: fix typos concerning "registration"
Date: Tue, 26 Oct 2010 21:57:16 +0200
Message-Id: <1288123039-22368-19-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/common/vic.c             |    2 +-
 arch/arm/mach-spear3xx/spear300.c |    4 ++--
 arch/arm/mach-spear3xx/spear310.c |    2 +-
 arch/arm/mach-spear3xx/spear320.c |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c |    6 +++---
 arch/arm/mach-spear6xx/spear6xx.c |    4 ++--
 net/core/dev.c                    |    2 +-
 sound/core/init.c                 |    2 +-
 8 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/common/vic.c b/arch/arm/common/vic.c
index ba65f6e..cb660bc 100644
--- a/arch/arm/common/vic.c
+++ b/arch/arm/common/vic.c
@@ -70,7 +70,7 @@ static inline struct vic_device *to_vic(struct sys_device *sys)
  * vic_init2 - common initialisation code
  * @base: Base of the VIC.
  *
- * Common initialisation code for registeration
+ * Common initialisation code for registration
  * and resume.
 */
 static void vic_init2(void __iomem *base)
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index 3560f8c..5aa2d54 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -371,7 +371,7 @@ struct pmx_driver pmx_driver = {
 };
 
 /* Add spear300 specific devices here */
-/* arm gpio1 device registeration */
+/* arm gpio1 device registration */
 static struct pl061_platform_data gpio1_plat_data = {
 	.gpio_base	= 8,
 	.irq_base	= SPEAR_GPIO1_INT_BASE,
@@ -451,7 +451,7 @@ void __init spear300_init(void)
 	/* call spear3xx family common init function */
 	spear3xx_init();
 
-	/* shared irq registeration */
+	/* shared irq registration */
 	shirq_ras1.regs.base =
 		ioremap(SPEAR300_TELECOM_BASE, SPEAR300_TELECOM_REG_SIZE);
 	if (shirq_ras1.regs.base) {
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 96a1ab8..53b41b5 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -266,7 +266,7 @@ void __init spear310_init(void)
 	/* call spear3xx family common init function */
 	spear3xx_init();
 
-	/* shared irq registeration */
+	/* shared irq registration */
 	base = ioremap(SPEAR310_SOC_CONFIG_BASE, SPEAR310_SOC_CONFIG_SIZE);
 	if (base) {
 		/* shirq 1 */
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index 6a12195..88b4652 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -519,7 +519,7 @@ void __init spear320_init(void)
 	/* call spear3xx family common init function */
 	spear3xx_init();
 
-	/* shared irq registeration */
+	/* shared irq registration */
 	base = ioremap(SPEAR320_SOC_CONFIG_BASE, SPEAR320_SOC_CONFIG_SIZE);
 	if (base) {
 		/* shirq 1 */
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index e87313a..52f553c 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -22,7 +22,7 @@
 #include <mach/spear.h>
 
 /* Add spear3xx machines common devices here */
-/* gpio device registeration */
+/* gpio device registration */
 static struct pl061_platform_data gpio_plat_data = {
 	.gpio_base	= 0,
 	.irq_base	= SPEAR_GPIO_INT_BASE,
@@ -41,7 +41,7 @@ struct amba_device gpio_device = {
 	.irq = {IRQ_BASIC_GPIO, NO_IRQ},
 };
 
-/* uart device registeration */
+/* uart device registration */
 struct amba_device uart_device = {
 	.dev = {
 		.init_name = "uart",
@@ -543,6 +543,6 @@ void spear_pmx_init(struct pmx_driver *pmx_driver, uint base, uint size)
 
 pmx_fail:
 	if (ret)
-		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
+		printk(KERN_ERR "padmux: registration failed. err no: %d\n",
 				ret);
 }
diff --git a/arch/arm/mach-spear6xx/spear6xx.c b/arch/arm/mach-spear6xx/spear6xx.c
index baf6bcc..f2fe14e 100644
--- a/arch/arm/mach-spear6xx/spear6xx.c
+++ b/arch/arm/mach-spear6xx/spear6xx.c
@@ -23,7 +23,7 @@
 #include <mach/spear.h>
 
 /* Add spear6xx machines common devices here */
-/* uart device registeration */
+/* uart device registration */
 struct amba_device uart_device[] = {
 	{
 		.dev = {
@@ -50,7 +50,7 @@ struct amba_device uart_device[] = {
 	}
 };
 
-/* gpio device registeration */
+/* gpio device registration */
 static struct pl061_platform_data gpio_plat_data[] = {
 	{
 		.gpio_base	= 0,
diff --git a/net/core/dev.c b/net/core/dev.c
index e8a8dc1..e5edf3b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6100,7 +6100,7 @@ static void __net_exit default_device_exit(struct net *net)
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
 {
 	/* At exit all network devices most be removed from a network
-	 * namespace.  Do this in the reverse order of registeration.
+	 * namespace.  Do this in the reverse order of registration.
 	 * Do this across as many network namespaces as possible to
 	 * improve batching efficiency.
 	 */
diff --git a/sound/core/init.c b/sound/core/init.c
index 57b792e2..3e65da2 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -642,7 +642,7 @@ static struct device_attribute card_number_attrs =
  *  external accesses.  Thus, you should call this function at the end
  *  of the initialization of the card.
  *
- *  Returns zero otherwise a negative error code if the registrain failed.
+ *  Returns zero otherwise a negative error code if the registration failed.
  */
 int snd_card_register(struct snd_card *card)
 {
-- 
1.7.2.3


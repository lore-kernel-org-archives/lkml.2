Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1LVVDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:03:00 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42177 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1LVVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:02:57 -0500
X-Originating-IP: 217.70.178.136
X-Originating-IP: 83.160.107.163
Date: Thu, 22 Dec 2011 22:00:50 +0100
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Documentation/pinctrl.txt: Fix variable name in GPIO example
 code
Message-ID: <20111222210050.GO5049@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix name of struct pinctrl_gpio_range for GPIO block "chip b"

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 Documentation/pinctrl.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index b04cb7d..399a300 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -218,7 +218,7 @@ static struct pinctrl_gpio_range gpio_range_a = {
 	.gc = &chip_a;
 };
 
-static struct pinctrl_gpio_range gpio_range_a = {
+static struct pinctrl_gpio_range gpio_range_b = {
 	.name = "chip b",
 	.id = 0,
 	.base = 48,
-- 
1.7.7.3


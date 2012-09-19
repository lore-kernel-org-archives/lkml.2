Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2ISI56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 04:57:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55119 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab2ISI5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 04:57:49 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <rob.herring@calxeda.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gpio: adnp: dt: Reference generic interrupt binding
Date: Wed, 19 Sep 2012 10:57:36 +0200
Message-Id: <1348045056-29769-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
References: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:RiJ8I4Yud1AMHBeoDwKsofftT1/3WX1Qk4/JH3Y9DwR
 kHlveKxdzQd1HxpI7C0cqO1odJWD8WrYra8Mq0M55TOH/8n7KX
 Vs2dmWUbW7FBol5twktV3zuBpkDuTIwMjD8V9H5jDc0rS6QnR1
 +d00AiYe+bxHa7qJ+2P5462MmrW176JTdW5uKEztgpJh4fn1sN
 w+2/cgT2pwoCwSzHImCxHMADFjat165RutGks1+RgQbTOjWNm3
 iiNn5e/+c5Z5cjPWnjIts+egCqY6sQQQgl5zICuFTqLoZlAtod
 AvRXwSW80s9DL/hgVaXn6HZ8BiIsqIbTMY5n5Y7ITBTG8BQKkk
 tzdsDi4BHSLG2Mno9RxznrGQ6i3pl3i+NxvlvoIYi7bl90r4zJ
 2kq//kxkwiTHgxfUi3RtnO1cXBN0rZe4pHC+pR9jCNzJRhlM4Y
 ce/wW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having to duplicate the description of the properties needed
for interrupt support, reference the new standard document.

Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
This patch should go through LinusW's tree because it already carries
the patch that created this documentation.

 Documentation/devicetree/bindings/gpio/gpio-adnp.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
index 5a09a21..625eee7 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-adnp.txt
@@ -11,6 +11,10 @@ Required properties:
 - gpio-controller: Marks the device as a GPIO controller
 - nr-gpios: The number of pins supported by the controller.
 
+The GPIO exander can optionally be used as an interrupt controller, in
+which case it uses the default two cell specifier as described in
+Documentation/devicetree/bindings/interrupt-controller/interrupts.txt.
+
 Example:
 
 	gpioext: gpio-controller@41 {
-- 
1.7.12


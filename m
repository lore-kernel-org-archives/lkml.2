Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946719Ab2LFSjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:39:54 -0500
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:42871 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946405Ab2LFSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:39:52 -0500
X-Greylist: delayed 6838 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 13:39:52 EST
From: Boris BREZILLON <linux-arm@overkiz.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <linux-arm@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH 0/1] pwm: atmel: TCB pwm driver
Date: Thu,  6 Dec 2012 17:45:22 +0100
Message-Id: <cover.1354810562.git.linux-arm@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 14678357086455444502
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeehiedrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfhrhhomhepuehorhhishcuueftgfgkkffnnffqpfcuoehlihhnuhigqdgrrhhmsehovhgvrhhkihiirdgtohhmqeenucfjughrpefhvffufffkofestddtredtredttd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch adds support for Timer Counter Block PWM.
TCB PWM chip provides 6 pwm devices.
This PWM devices are grouped by 2 (0/1, 2/3 and 4/5).
The PWM devices in a given group must use the same period_ns value.


Regards,

Boris

--
Boris BREZILLON (1):
  pwm: atmel: add Timer Counter Block PWM driver

 .../devicetree/bindings/pwm/atmel-tcb-pwm.txt      |   15 +
 drivers/pwm/Kconfig                                |    8 +
 drivers/pwm/Makefile                               |    1 +
 drivers/pwm/pwm-atmel-tcb.c                        |  335 ++++++++++++++++++++
 4 files changed, 359 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-tcb-pwm.txt
 create mode 100644 drivers/pwm/pwm-atmel-tcb.c


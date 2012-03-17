Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2CQKN2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 06:13:28 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:41105
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab2CQKNZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 06:13:25 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzc89bhzz1202hzzz2dh2a8h668h839h93fhd24hd2bh)
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: [PATCH 00/02] DA9052 patch series
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: <linux-kernel@vger.kernel.org>
CC: Dajun <dajun.chen@diasemi.com>, <linux-watchdog@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Mar 2012 15:32:53 +0530
Message-ID: <1331978573.7058.68.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-Originating-IP: [10.10.38.47]
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿The following patch series adds support for the ADC functionality in
MFD and HWMON modules for Dialog Semiconductor DA9052/53 PMICs.

The HWMON patch depends on the ADC patch.

Ashish Jangam (2):
        [MFD]: Incremental patch for ADC support in DA9052/53 MFD
module.
        [HWMON]: HWMON driver for DA9052/53 PMICs. This patch is ACK-by
Guenter Roeck however requires a minor modification.

 Documentation/hwmon/da9052        |   61 +++++++
 drivers/hwmon/Kconfig             |   10 +
 drivers/hwmon/Makefile            |    1 +
 drivers/hwmon/da9052-hwmon.c      |  344
+++++++++++++++++++++++++++++++++++++
 drivers/mfd/da9052-core.c         |  136 +++++++++++++++
 include/linux/mfd/da9052/da9052.h |   20 ++
 6 files changed, 572 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwmon/da9052
 create mode 100644 drivers/hwmon/da9052-hwmon.c
        


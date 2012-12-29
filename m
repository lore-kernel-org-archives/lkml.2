Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2L2KPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 05:15:08 -0500
Received: from mout.web.de ([212.227.17.11]:53025 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab2L2KPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 05:15:03 -0500
From: Daniel Schaal <farbing@web.de>
To: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Daniel Schaal <farbing@web.de>
Subject: [PATCH] Bluetooth: Add support for GC-WB300D PCIe [04ca:3006]
Date: Sat, 29 Dec 2012 11:14:33 +0100
Message-Id: <1356776074-1703-1-git-send-email-farbing@web.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V02:K0:zDuah9wb/N4CLuHT9KSaiMdIdoDq/c7QfmWB27iKz04
 UNlLm8A4QK+uXFFgsyl8fYIpwGdAs5qjegetGIJi6e3Vg0zh/B
 tryPl/E31cuRpgKSt2/lkMgzNDv99mf00M6lyIc7fuuaVl8azn
 uVn62cQ7lcnA0rRZcXwNIti0JRxRs3cnrWnk9SgfX64+cuA8Yl
 fAc5pH6ofaEOfwtSY4Gog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds support for the bluetooth part of
Gigabyte's GC-WB300D PCIe card (combo card with AR9462 WLAN
and ATH3012 BT).

On every boot there is an error from this device:

usb 2-1.7: string descriptor 0 read error: -22

But that doesn't seem to have any negative effect AFAICT.

It also needed a newer firmware than is in linux-firmware.git,
using the one from the Windows driver worked fine.
(AthrBT_0x11020000.dfu and ramps_0x11020000_40.dfu)

Daniel Schaal (1):
  Bluetooth: Add support for GC-WB300D PCIe [04ca:3006] to ath3k.

 drivers/bluetooth/ath3k.c |    2 ++
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 3 insertions(+)

-- 
1.7.10.4


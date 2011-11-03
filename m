Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1KCVNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:13:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62545 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1KCVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:13:12 -0400
Message-ID: <4EB3022A.7060900@gmail.com>
Date: Thu, 03 Nov 2011 16:05:46 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PULL]  more devicetree for 3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

Please pull a couple of device tree updates for 3.2.

The branch commit id is 02aac316abf436a7529d46a71f7083f9f9ef4b49.

The following changes since commit 994c0e992522c123298b4a91b72f5e67ba2d1123:

  Merge branch 'next/soc' of git://git.linaro.org/people/arnd/arm-soc
(2011-11-01 21:08:03 -0700)

are available in the git repository at:

  git://sources.calxeda.com/kernel/linux.git for-grant

Olof Johansson (1):
      dt/platform: minor cleanup

Rob Herring (1):
      ahci: add DT binding for Calxeda AHCI controller

 .../devicetree/bindings/ata/calxeda-sata.txt       |   17 ++++++++++++
 drivers/ata/ahci_platform.c                        |    7 +++++
 drivers/of/platform.c                              |   28
+++++++++++--------
 3 files changed, 40 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/calxeda-sata.txt

Rob

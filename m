Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2IRIbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:31:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:33280 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab2IRIbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:31:19 -0400
Message-ID: <5058313F.8060704@atmel.com>
Date: Tue, 18 Sep 2012 10:30:55 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        voice <voice.shen@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] at91: one fix for 3.6
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd, Olof,

We have one last minute fix. It can help us to use the device tree for 
GPIO interrupt attached devices. I have based my tag on top of the "fixes" pull 
request that I've already sent to you.
I hope that it could make it for 3.6-final.

The following changes since commit 51a6149b89b822cacf572b2ca2a15cb6f2232b11:

  ARM: at91/feature-removal-schedule: delay at91_mci removal (2012-08-27 09:59:36 +0200)

are available in the git repository at:

  git://github.com/at91linux/linux-at91.git tags/at91-fixes

for you to fetch changes up to 51ac51a6a5ab5f0aff46c4757ba4c32f3f8f7a2e:

  ARM: at91: fix missing #interrupt-cells on gpio-controller (2012-09-17 10:25:01 +0200)

----------------------------------------------------------------
Modify AT91 device tree files for making the GPIO interrupts work.

----------------------------------------------------------------
Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: fix missing #interrupt-cells on gpio-controller

 arch/arm/boot/dts/at91sam9260.dtsi | 3 +++
 arch/arm/boot/dts/at91sam9263.dtsi | 5 +++++
 arch/arm/boot/dts/at91sam9g45.dtsi | 5 +++++
 arch/arm/boot/dts/at91sam9n12.dtsi | 4 ++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 4 ++++
 5 files changed, 21 insertions(+)

Thanks, best regards,
-- 
Nicolas Ferre

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2JEPcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 11:32:01 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61389 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2JEPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 11:31:59 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/10] Platform data clean-up and UIB device enablement
Date: Fri,  5 Oct 2012 16:31:36 +0100
Message-Id: <1349451107-8009-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch-set we move all Device Tree start-up code from the u8500
board file and into the more persistent db8500 cpu file. This will aid
future endeavours to remove platform code completely from Mainline. We
also enable some of the devices found on the STUIB (User Interface
board), which attaches to some of ST-Ericsson's reference platforms.

 .../devicetree/bindings/input/stmpe-keypad.txt     |   39 +++++
 Documentation/devicetree/bindings/mfd/stmpe.txt    |   25 ++++
 arch/arm/boot/dts/stuib.dtsi                       |   40 ++++++
 drivers/input/keyboard/stmpe-keypad.c              |   67 +++++++--
 drivers/mfd/stmpe.c                                |  152 +++++++++++++-------
 drivers/of/of_i2c.c                                |    3 +
 include/linux/mfd/stmpe.h                          |    2 +
 7 files changed, 271 insertions(+), 57 deletions(-)


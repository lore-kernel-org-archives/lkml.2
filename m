Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2JBINg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:13:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45009 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JBINd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:13:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: [PATCH 00/10] Platform data clean-up and UIB device enablement
Date: Tue,  2 Oct 2012 09:13:13 +0100
Message-Id: <1349165603-24401-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this patch-set we move all Device Tree start-up code from the u8500
board file and into the more persistent db8500 cpu file. This will aid
future endeavours to remove platform code completely from Mainline. We
also enable some of the devices found on the STUIB (User Interface
board), which attaches to some of ST-Ericsson's reference platforms.

  .../bindings/input/touchscreen/bu21013.txt         |   28 +++++
  arch/arm/boot/dts/hrefprev60.dts                   |    7 ++
  arch/arm/boot/dts/hrefv60plus.dts                  |    9 ++
  arch/arm/boot/dts/stuib.dtsi                       |   38 +++++++
  arch/arm/mach-ux500/board-mop500-stuib.c           |   92 +--------------
  arch/arm/mach-ux500/board-mop500.c                 |  105 +-----------------
  arch/arm/mach-ux500/board-mop500.h                 |    8 +-
  arch/arm/mach-ux500/cpu-db8500.c                   |  104 ++++++++++++++++-
  drivers/input/touchscreen/bu21013_ts.c             |  117 +++++++++++++++++---
  include/linux/input/bu21013.h                      |    8 +-
  10 files changed, 299 insertions(+), 217 deletions(-)


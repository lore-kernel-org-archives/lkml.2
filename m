Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0KLJXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:23:33 -0500
Received: from smtp.nokia.com ([147.243.128.24]:53341 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459Ab0KLJXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:23:31 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/4] OMAP: Serial: remove magic and diplicates
Date: Fri, 12 Nov 2010 11:21:38 +0200
Message-Id: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Add MDR1 Serial register definition to serial_reg and remove duplicated
code.
*v2 add OMAP keyword to MDR1 definition
*v3 remove magic from serial drivers

Andrei Emeltchenko (4):
  OMAP: Serial: Define OMAP uart MDR1 register definitions
  OMAP1: Serial: remobe magic from MDR1 register
  OMAP2: Serial: remobe magic from MDR1 register
  OMAP: Serial: remove redefined MDR1 register definitions

 arch/arm/mach-omap1/serial.c                  |    6 ++++--
 arch/arm/mach-omap2/serial.c                  |   15 +++++++++------
 arch/arm/plat-omap/include/plat/omap-serial.h |    3 ---
 drivers/serial/omap-serial.c                  |    6 +++---
 include/linux/serial_reg.h                    |   12 ++++++++++++
 5 files changed, 28 insertions(+), 14 deletions(-)


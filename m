Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0HWOCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:02:01 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:19590 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0HWOB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:01:59 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org, akpm@kernel.org
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH RFC 0/1] MISC: Broadcom BCM4751 GPS driver
Date: Mon, 23 Aug 2010 17:00:25 +0300
Message-Id: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com>
X-Mailer: git-send-email 1.6.1.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is a driver for Broadcom's BCM4751 GPS chip and
this is the first time this driver is sent for review, 
all comments are welcome.

Thanks,
Matti A.

Matti J. Aaltonen (1):
  MISC: Broadcom BCM4751 GPS driver

 drivers/misc/Kconfig            |   11 +
 drivers/misc/Makefile           |    1 +
 drivers/misc/bcm4751-gps.c      |  490 +++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/bcm4751-gps.h |   59 +++++
 4 files changed, 561 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/bcm4751-gps.c
 create mode 100644 include/linux/i2c/bcm4751-gps.h


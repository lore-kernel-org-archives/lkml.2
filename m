Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2GYGaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:30:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49738 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab2GYGaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:30:08 -0400
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Katsuya MATSUBARA <matsu@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH 0/2] Renesas IPMMU driver for sh7372
Date: Wed, 25 Jul 2012 15:29:00 +0900
Message-Id: <1343197742-13630-1-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Renesas IPMMU driver, IOMMU API implementation and IPMMU
device support for sh7372 (AP4EVB and Mackerel).

The IPMMU module supports the MMU function and the PMB function.  The
MMU function provides address translation by pagetable compatible with
ARMv6.  The PMB function provides address translation including
tile-linear translation.  This is implementation of the MMU function.

Hideki EIRAKU (2):
  iommu/shmobile: Add iommu driver for Renesas IPMMU modules
  ARM: mach-shmobile: sh7372: Add IPMMU device

 arch/arm/mach-shmobile/Kconfig              |    6 +
 arch/arm/mach-shmobile/Makefile             |    3 +
 arch/arm/mach-shmobile/board-ap4evb.c       |    5 +
 arch/arm/mach-shmobile/board-mackerel.c     |    5 +
 arch/arm/mach-shmobile/include/mach/ipmmu.h |   10 +
 arch/arm/mach-shmobile/ipmmu.c              |  137 ++++++++++++
 arch/arm/mach-shmobile/setup-sh7372.c       |   22 ++
 drivers/iommu/Kconfig                       |    7 +
 drivers/iommu/Makefile                      |    1 +
 drivers/iommu/shmobile-iommu.c              |  318 +++++++++++++++++++++++++++
 10 files changed, 514 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/include/mach/ipmmu.h
 create mode 100644 arch/arm/mach-shmobile/ipmmu.c
 create mode 100644 drivers/iommu/shmobile-iommu.c


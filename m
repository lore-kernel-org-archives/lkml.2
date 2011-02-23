Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1BWOBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 09:01:04 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52528 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab1BWNxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:53:03 -0500
From: Pratheesh Gangadhar <pratheesh@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: hjk@hansjkoch.de, gregkh@suse.de, pratheesh@ti.com, amit.chatterjee@ti.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/2] Add PRUSS UIO driver support
Date: Wed, 23 Feb 2011 19:22:39 +0530
Message-Id: <1298469161-7644-1-git-send-email-pratheesh@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for PRUSS (Programmable Real-time Unit Sub
System) UIO driver in Texas Instruments DA850, AM18xx and OMAPL1-38 processors.
PRUSS is programmable RISC core which can be used to implement Soft IPs
(eg:- DMA, CAN, UART,SmartCard) and Industrial communications data link layers
(eg:- PROFIBUS). UIO driver exposes PRUSS resources like memory and interrupts 
to user space application.PRUSS UIO application API can be used to control PRUs
 in PRUSS, setup PRU INTC, load firmware to PRUs and implement IPC between Host
 processor and PRUs. More information on PRUSS and UIO linux user space API 
available in the links below

http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader
http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader_API_Guide

Pratheesh Gangadhar (2):
  PRUSS UIO driver support
  Defines DA850/AM18xx/OMAPL1-38 SOC resources used by PRUSS UIO driver

 arch/arm/mach-davinci/board-da850-evm.c    |    4 +
 arch/arm/mach-davinci/da850.c              |   35 +++++
 arch/arm/mach-davinci/devices-da8xx.c      |   73 +++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    3 +
 drivers/uio/Kconfig                        |   17 ++
 drivers/uio/Makefile                       |    1 +
 drivers/uio/uio_pruss.c                    |  223 ++++++++++++++++++++++++++++
 7 files changed, 356 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pruss.c


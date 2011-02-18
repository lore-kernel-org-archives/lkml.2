Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1BRPFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:05:53 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53675 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab1BRPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:05:50 -0500
From: Pratheesh Gangadhar <pratheesh@ti.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: hjk@linutronix.de, gregkh@suse.de, pratheesh@ti.com,
        amit.chatterjee@ti.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Add PRUSS UIO driver support
Date: Fri, 18 Feb 2011 20:35:28 +0530
Message-Id: <1298041530-26855-1-git-send-email-pratheesh@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for PRUSS (Programmable Real-time Unit Sub System) UIO driver in Texas Instruments DA850, AM18xx and OMAPL1-38 processors. PRUSS is programmable RISC core which can be used to implement Soft IPs (eg:- DMA, CAN, UART,SmartCard) and Industrial communications data link layers (eg:- PROFIBUS). UIO driver exposes PRUSS resources like memory and interrupts to user space application.PRUSS UIO application API can be used to control PRUs in PRUSS, setup PRU INTC, load firmware to PRUs and implement IPC between Host processor and PRUs. More information on PRUSS and UIO linux user space API available in the links below

http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader
http://processors.wiki.ti.com/index.php/PRU_Linux_Application_Loader_API_Guide 

PRUSS UIO driver support patch applies on top of Linus's tree latest.
Both patches applies on top of linux-davinci tree latest. 

Pratheesh Gangadhar (2):
  PRUSS UIO driver support
  Defines DA850/AM18xx/OMAPL1-38 SOC resources used by PRUSS UIO driver

 arch/arm/mach-davinci/board-da850-evm.c    |    4 +
 arch/arm/mach-davinci/da850.c              |   35 ++++
 arch/arm/mach-davinci/devices-da8xx.c      |   73 ++++++++
 arch/arm/mach-davinci/include/mach/da8xx.h |    3 +
 drivers/uio/Kconfig                        |   10 +
 drivers/uio/Makefile                       |    1 +
 drivers/uio/uio_pruss.c                    |  250 ++++++++++++++++++++++++++++
 7 files changed, 376 insertions(+), 0 deletions(-)
 create mode 100644 drivers/uio/uio_pruss.c


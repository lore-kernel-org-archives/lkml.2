Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab0C3Oyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:54:50 -0400
Received: from mx2.zhaw.ch ([160.85.104.51]:43245 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0C3Oyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:54:49 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: linux-serial@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Tobias Klauser <tklauser@distanz.ch>, gregkh@suse.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] serial: Drivers for Altera UARTs
Date: Tue, 30 Mar 2010 16:54:40 +0200
Message-Id: <cover.1269960350.git.tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.3.11.95718
X-PerlMx-Spam: Gauge=X, Probability=10%, Report='
 TO_IN_SUBJECT 0.5, BODY_SIZE_1100_1199 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fourth version of the patchset to add the serial drivers for the
Altera UARTs. The following changes were made on top of the third version
submitted on 5 Mar 2010:

 - altera_uart: Remove usage of altera_uart_getppdcd, altera_uart_getppdtr,
   altera_uart_setppdtr. This makes altera_uart actually compile again (verified
   on x86_64 with Linus' master branch as of today).

Cheers,
Tobias

Tobias Klauser (2):
  serial: Add driver for the Altera JTAG UART
  serial: Add driver for the Altera UART

 drivers/serial/Kconfig           |   52 ++++
 drivers/serial/Makefile          |    2 +
 drivers/serial/altera_jtaguart.c |  504 +++++++++++++++++++++++++++++++++
 drivers/serial/altera_uart.c     |  570 ++++++++++++++++++++++++++++++++++++++
 include/linux/altera_jtaguart.h  |   16 +
 include/linux/altera_uart.h      |   14 +
 include/linux/serial_core.h      |    4 +
 7 files changed, 1162 insertions(+), 0 deletions(-)
 create mode 100644 drivers/serial/altera_jtaguart.c
 create mode 100644 drivers/serial/altera_uart.c
 create mode 100644 include/linux/altera_jtaguart.h
 create mode 100644 include/linux/altera_uart.h


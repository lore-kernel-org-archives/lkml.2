Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab0EEIpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 04:45:40 -0400
Received: from mx1.zhaw.ch ([160.85.104.50]:37511 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933884Ab0EEIpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 04:45:38 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: linux-serial@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org,
       Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH v5 0/2] serial: Drivers for Altera UARTs
Date: Wed,  5 May 2010 10:35:21 +0200
Message-Id: <cover.1273048151.git.tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.3.3
To: linux-serial@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.5.5.82415
X-PerlMx-Spam: Gauge=X, Probability=10%, Report='
 TO_IN_SUBJECT 0.5, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1200_1299 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, TO_NO_NAME 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the fifth version of the patchset to add the serial drivers for the
Altera UARTs. The following changes were made on top of the fourth version
submitted on 30 Mar 2010:

 - Fix Kconfig so altera_uart and altera_jtaguart can be properly built as
   modules. Add dependecy SERIAL_ALTERA_JTAGUART=y (instead of just
   SERIAL_ALTERA_JTAGUART) to SERIAL_ALTERA_JTAGUART_CONSOLE to prevent build
   failure when building as module (accordingly for the altera_uart driver).
   Thanks to Stephen Rothwell for the help with this.

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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1BIJvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:51:13 -0500
Received: from mx1.zhaw.ch ([160.85.104.50]:64222 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1BIJvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:51:11 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] *** SUBJECT HERE ***
Date: Wed,  9 Feb 2011 10:51:10 +0100
Message-Id: <cover.1297244810.git.tklauser@distanz.ch>
X-Mailer: git-send-email 1.7.0.4
X-PMX-Version: 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.2.9.94223
X-PerlMx-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1000_LESS 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_600_699 0, BODY_SIZE_7000_LESS 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __SANE_MSGID 0, __TO_MALFORMED_2 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Tobias Klauser (4):
  tty: serial: altera_uart: Handle pdev->id == -1 in altera_uart_remove
  tty: serial: altera_uart: Use port->regshift to store bus shift
  tty: serial: altera_uart: Add devicetree support
  MAINTAINERS: Add myself as a maintainer for
    altera_uart/altera_jtaguart

 .../devicetree/bindings/serial/altera_uart.txt     |    7 ++
 MAINTAINERS                                        |   10 +++
 drivers/tty/serial/altera_uart.c                   |   69 ++++++++++++++++----
 3 files changed, 74 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/serial/altera_uart.txt


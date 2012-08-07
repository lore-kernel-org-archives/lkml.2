Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048Ab2HGGyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 02:54:55 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:37952 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2HGGyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 02:54:53 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gregkh@linuxfoundation.org>
Cc: <sjur.brandeland@stericsson.com>, <arun.murthy@stericsson.com>
Subject: [PATCHv2 0/4] modem_shm: U8500 SHaRed Memory driver(SHRM)
Date: Tue, 7 Aug 2012 12:24:27 +0530
Message-ID: <1344322471-3640-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In u8500 platform the communication between the APE(Application Processor) and
the modem subsystem(CMT) is by means of a shared DDR. The series of patches
include a protocol called ShaRed Memory(SHRM) protocol for communicating
between the APE and the CMT.
Interrupt generation registers in CMT and PRCMU on APE side are used to support
the shrm protocol.

Arun Murthy (4):
  modem_shm: Add Modem Access Framework
  modem_shm: Register u8500 client for MAF
  modem_shm: u8500-shm: U8500 Shared Memory Driver
  Doc: Add u8500_shrm document

 Documentation/DocBook/Makefile                   |    2 +-
 Documentation/DocBook/shrm.tmpl                  |  125 ++
 Documentation/modem_shm/u8500_shrm.txt           |  254 ++++
 drivers/Kconfig                                  |    2 +
 drivers/Makefile                                 |    1 +
 drivers/modem_shm/Kconfig                        |   22 +
 drivers/modem_shm/Makefile                       |    3 +
 drivers/modem_shm/modem_access.c                 |  419 ++++++
 drivers/modem_shm/modem_u8500.c                  |   96 ++
 drivers/modem_shm/u8500_shm/Kconfig              |   43 +
 drivers/modem_shm/u8500_shm/Makefile             |    7 +
 drivers/modem_shm/u8500_shm/shrm_char.c          |  895 ++++++++++++
 drivers/modem_shm/u8500_shm/shrm_driver.c        |  732 ++++++++++
 drivers/modem_shm/u8500_shm/shrm_fifo.c          |  837 ++++++++++++
 drivers/modem_shm/u8500_shm/shrm_net.c           |  312 +++++
 drivers/modem_shm/u8500_shm/shrm_protocol.c      | 1590 ++++++++++++++++++++++
 include/linux/modem_shm/modem.h                  |   64 +
 include/linux/modem_shm/modem_client.h           |   55 +
 include/linux/modem_shm/u8500_shm/shrm.h         |   23 +
 include/linux/modem_shm/u8500_shm/shrm_config.h  |  114 ++
 include/linux/modem_shm/u8500_shm/shrm_driver.h  |  225 +++
 include/linux/modem_shm/u8500_shm/shrm_ioctl.h   |   43 +
 include/linux/modem_shm/u8500_shm/shrm_net.h     |   46 +
 include/linux/modem_shm/u8500_shm/shrm_private.h |  183 +++
 24 files changed, 6092 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/DocBook/shrm.tmpl
 create mode 100644 Documentation/modem_shm/u8500_shrm.txt
 create mode 100644 drivers/modem_shm/Kconfig
 create mode 100644 drivers/modem_shm/Makefile
 create mode 100644 drivers/modem_shm/modem_access.c
 create mode 100644 drivers/modem_shm/modem_u8500.c
 create mode 100644 drivers/modem_shm/u8500_shm/Kconfig
 create mode 100644 drivers/modem_shm/u8500_shm/Makefile
 create mode 100644 drivers/modem_shm/u8500_shm/shrm_char.c
 create mode 100644 drivers/modem_shm/u8500_shm/shrm_driver.c
 create mode 100644 drivers/modem_shm/u8500_shm/shrm_fifo.c
 create mode 100644 drivers/modem_shm/u8500_shm/shrm_net.c
 create mode 100644 drivers/modem_shm/u8500_shm/shrm_protocol.c
 create mode 100644 include/linux/modem_shm/modem.h
 create mode 100644 include/linux/modem_shm/modem_client.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm_config.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm_driver.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm_ioctl.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm_net.h
 create mode 100644 include/linux/modem_shm/u8500_shm/shrm_private.h

-- 
1.7.4.3


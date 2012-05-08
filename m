Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2EHKBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:01:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59214 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2EHKBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:01:18 -0400
X-AuditID: cbfee61a-b7b97ae000004342-f0-4fa8eeec2363
Message-id: <4FA8EF06.6020108@samsung.com>
Date: Tue, 08 May 2012 19:01:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use Extcon framework in extcon-max8997 driver to control
external connector instead of max8997-muic driver which is implemented
with callback function through platform_data to control external connector.

So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
the last patch remove previous MAX8997 MUIC
driver(drivers/misc/max8997-muic.c)
which support MUIC feature of Maxim MAX8997 with callback function.

Chanwoo Choi (2):
  Extcon: add MAX8997 extcon driver
  misc: MAX8997: Remove max8997-muic driver

 drivers/extcon/Kconfig          |    8 +
 drivers/extcon/Makefile         |    1 +
 drivers/extcon/extcon-max8997.c |  542
+++++++++++++++++++++++++++++++++++++++
 drivers/misc/Kconfig            |    8 -
 drivers/misc/Makefile           |    1 -
 drivers/misc/max8997-muic.c     |  495 -----------------------------------
 include/linux/mfd/max8997.h     |   23 --
 7 files changed, 551 insertions(+), 527 deletions(-)
 create mode 100644 drivers/extcon/extcon-max8997.c
 delete mode 100644 drivers/misc/max8997-muic.c

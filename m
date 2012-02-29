Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030964Ab2B2OA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:00:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58468 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab2B2OA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:00:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rsayakhova@gmail.com designates 10.180.86.105 as permitted sender) smtp.mail=rsayakhova@gmail.com; dkim=pass header.i=rsayakhova@gmail.com
From: Renata Sayakhova <rsayakhova@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, rsayakhova@gmail.com
Subject: [PATCH 0001] DS2781 Maxim Stand-Alone Fuel Gauge battery and w1 slave drivers
Date: Wed, 29 Feb 2012 14:58:52 +0100
Message-Id: <1330523933-32344-1-git-send-email-rsayakhova@gmail.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FROM: Renata Sayakhova <renata@oktetlabs.ru>

Implementation of DS2781 Maxim Stand-Alone Fuel Gauge battery and w1 slave drivers.

Renata Sayakhova (1):
  DS2781 Maxim Stand-Alone Fuel Gauge battery and w1 slave drivers

 drivers/power/Kconfig          |   14 +
 drivers/power/Makefile         |    1 +
 drivers/power/ds2781_battery.c |  874 ++++++++++++++++++++++++++++++++++++++++
 drivers/w1/slaves/Kconfig      |   13 +
 drivers/w1/slaves/Makefile     |    1 +
 drivers/w1/slaves/w1_ds2781.c  |  201 +++++++++
 drivers/w1/slaves/w1_ds2781.h  |  136 +++++++
 drivers/w1/w1_family.h         |    1 +
 8 files changed, 1241 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/ds2781_battery.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.c
 create mode 100644 drivers/w1/slaves/w1_ds2781.h

-- 
1.7.6.3


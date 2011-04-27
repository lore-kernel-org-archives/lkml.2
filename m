Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1D0GS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:18:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33671 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1D0GSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:18:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6328"; a="88047820"
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
To: sameo@linux.intel.com, grant.likely@secretlab.ca
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, dwalker@fifo99.com,
        davidb@codeaurora.org, linux-arm-msm-owner@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andres Salomon <dilinger@queued.net>,
        =?UTF-8?q?Uwe=20Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Subject: [PATCH 0/2] fix mpp and gpio for pm8921
Date: Tue, 26 Apr 2011 23:18:45 -0700
Message-Id: <1303885127-25220-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed here 
https://lkml.org/lkml/2011/4/26/326
removed the usage of mfd_get_data and moved back to using platform_data.

Grant please review and ack these.

Abhijeet Dharmapurikar (1):
  gpio: pm8xxx-gpio: Add pm8xxx gpio driver

David Collins (1):
  mfd: pm8xxx-mpp: Add pm8xxx MPP driver

 drivers/gpio/Kconfig              |   17 ++
 drivers/gpio/Makefile             |    2 +
 drivers/gpio/pm8xxx-gpio.c        |  455 +++++++++++++++++++++++++++++++++++++
 drivers/gpio/pm8xxx-mpp.c         |  325 ++++++++++++++++++++++++++
 drivers/mfd/pm8921-core.c         |   65 ++++++
 include/linux/mfd/pm8xxx/gpio.h   |  135 +++++++++++
 include/linux/mfd/pm8xxx/mpp.h    |  233 +++++++++++++++++++
 include/linux/mfd/pm8xxx/pm8921.h |   18 ++
 8 files changed, 1250 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/pm8xxx-gpio.c
 create mode 100644 drivers/gpio/pm8xxx-mpp.c
 create mode 100644 include/linux/mfd/pm8xxx/gpio.h
 create mode 100644 include/linux/mfd/pm8xxx/mpp.h

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759954Ab2BNJVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 04:21:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59760 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759690Ab2BNJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 04:21:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6619"; a="162976222"
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>, Anssi Hannula <anssi.hannula@iki.fi>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
        linux-media@vger.kernel.org, davidb@codeaurora.org,
        bryanh@codeaurora.org, tsoni@codeaurora.org,
        Ravi Kumar V <kumarrav@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Add support for MSM GPIO IR receiver driver
Date: Tue, 14 Feb 2012 14:50:56 +0530
Message-Id: <1329211256-12896-1-git-send-email-kumarrav@codeaurora.org>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is for GPIO based IR receivers, it can listen only to IR receiver 
modules which gives demodulated signal as output, this driver only passes the 
interrupt events to rc framework where pulse and space widths are calculated 
and input to decoders avaliable.

Ravi Kumar V (1):
  msm: rc: Add support for MSM GPIO based IR Receiver driver.

 drivers/media/rc/Kconfig        |    9 ++
 drivers/media/rc/Makefile       |    1 +
 drivers/media/rc/gpio-ir-recv.c |  189 +++++++++++++++++++++++++++++++++++++++
 include/media/gpio-ir-recv.h    |   23 +++++
 4 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/gpio-ir-recv.c
 create mode 100644 include/media/gpio-ir-recv.h

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


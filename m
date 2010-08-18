Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HRTPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:15:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3035 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0HRTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:15:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6078"; a="51340538"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca, gregkh@suse.de
Subject: [PATCH v3 0/4] platform: Facilitate the creation of pseudo-platform buses
Date: Wed, 18 Aug 2010 12:15:39 -0700
Message-Id: <1282158943-11902-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the interesting stuff is in patch 2/4 and 3/4, inline.

    (lkml.org seems to have lost August 3rd...)
    RFC: http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/01342.html
     v1: http://lkml.indiana.edu/hypermail/linux/kernel/1008.0/01942.html
     v2: http://lkml.indiana.edu/hypermail/linux/kernel/1008.1/00958.html

[PATCH 1/4] platform: Use drv->driver.bus instead of assuming platform_bus_type
    * This patch is already in greg k-h's queue, included only for clarity

[PATCH 2/4] platform: Facilitate the creation of pseudo-platform buses
    * This patch has changed pretty significantly, see its changelog

[PATCH 3/4] msm-bus: Define the msm-bus skeleton
    * This patch is a sample user of the new code, mostly proof-of-concept
      that defines a msm bus_type

[PATCH 4/4] msm: serial: Move msm_uart_driver onto msm bus
    * This patch simply moves a device/driver pair from the platform bus to
      the new msm bus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0H0ENh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 00:13:37 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45985 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0H0ENf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 00:13:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6086"; a="52282782"
From: Saravana Kannan <skannan@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org
Subject: Add system bus performance parameter
Date: Thu, 26 Aug 2010 21:13:22 -0700
Message-Id: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maintainers,

I'm adding this parameter since it would be useful to some of the drivers of
devices present in the ARM MSM chipsets.  Without the PM QoS parameter, there
appears to be no clean way (in my opinion) to get requests from multiple
drivers to increase the system bus performance (which is possible in MSM
chipsets).

Adding this parameter would also allow me to delete some code in the Android
specific implementation of arch/arm/mach-msm/clock.c that's unnecessarily
mach-msm specific and use the generic clkdev library that's available for the
ARM architecture. This would in turn allow me to upstream (after further clean
up) more code that's currently present only in the kernel used in Android.

Thanks,
Saravana
---
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

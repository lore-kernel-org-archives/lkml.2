Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab2ASKMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 05:12:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5910 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab2ASKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 05:12:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Jan 2012 02:12:38 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: swarren@nvidia.com, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH 0/3] rtc: twl: update TWL RTC driver 
Date: Thu, 19 Jan 2012 15:42:26 +0530
Message-Id: <1326967949-8248-1-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Venu Byravarasu <vbyravarasu@nvidia.com>

Observed minor issues with TWL RTC driver.
Hence tried fixing them with below 3 patches.

Venu Byravarasu (3):
  rtc: twl: Enable RTC irrespective of its prior state
  rtc: twl: Simplify RTC interrupt clearing
  rtc: twl: Return correct RTC event from ISR

 drivers/rtc/rtc-twl.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)


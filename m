Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1KFQq6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:46:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63028 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab1KFQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:46:57 -0500
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH 0/2] i.MX1 RTC fixes
Date: Sun,  6 Nov 2011 19:46:44 +0300
Message-Id: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. There are fixes for rtc_mxc driver here. Platform devices are still not
fixed, driver was tested with 2.6.37 kernel.

Yauhen Kharuzhy (2):
  RTC MXC: Fix setting time for MX1 SoC
  RTC MXC: Make alarm working

 drivers/rtc/rtc-mxc.c |  123 ++++++++++++++++++++++++++++---------------------
 1 files changed, 70 insertions(+), 53 deletions(-)

-- 
1.7.7.1


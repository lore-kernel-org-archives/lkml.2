Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab2KWHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:06:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55443 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab2KWHGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:06:37 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, patches@linaro.org
Subject: [PATCH 0/2] drivers/rtc/rtc-s3c.c: Add devm_* APIs and cleanup
Date: Fri, 23 Nov 2012 12:30:17 +0530
Message-Id: <1353654019-1099-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds devm_* APIs to rtc-s3c driver and cleans up the
probe function.

Tushar Behera (2):
  drivers/rtc/rtc-s3c.c: Remove unnecessary err_nores label
  drivers/rtc/rtc-s3c.c: Convert to use devm_* API

 drivers/rtc/rtc-s3c.c |   48 ++++++++----------------------------------------
 1 files changed, 8 insertions(+), 40 deletions(-)

-- 
1.7.4.1


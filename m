Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246Ab2KVS0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:26:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40387 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KVS0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:26:40 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, linux@prisktech.co.nz, patches@linaro.org
Subject: [PATCH 0/4] video: vt8500: cleanup and use of devm_ apis
Date: Thu, 22 Nov 2012 12:12:07 +0530
Message-Id: <1353566531-31251-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 fixes a possible memory leak in the driver.
Rest 3 patches add/update usage of devm_ apis.

These patches are only build-tested.

Tushar Behera (4):
  video: vt8500: Fix memory leak in probe function
  video: vt8500: Fix invalid free of devm_ allocated data
  video: vt8500: Convert to use devm_request_mem_region()
  video: vt8500: Convert to use devm_ioremap()

 drivers/video/vt8500lcdfb.c |   47 +++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 30 deletions(-)

-- 
1.7.4.1


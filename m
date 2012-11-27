Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2K0GFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 01:05:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48343 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2K0GFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 01:05:17 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, cbouatmailru@gmail.com, dwmw2@infradead.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 0/3] power: bq2415x_charger: Some cleanup
Date: Tue, 27 Nov 2012 11:28:43 +0530
Message-Id: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is build tested againt the linux-next tree (20121126)

Sachin Kamat (3):
  power: bq2415x_charger: Remove unneeded version.h inclusion
  power: bq2415x_charger: Use module_i2c_driver
  power: bq2415x_charger: Use devm_kzalloc()

 drivers/power/bq2415x_charger.c |   28 +++++++---------------------
 1 files changed, 7 insertions(+), 21 deletions(-)

-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1LGNxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:53:32 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47151 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab1LGNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:53:31 -0500
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Subject: [PATCH] Regulator: Add Anatop regulator driver
Date: Wed,  7 Dec 2011 21:53:17 +0800
Message-Id: <1323265998-29088-1-git-send-email-paul.liu@linaro.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>

Hi all,

This is the Anatop regulator used by Freescale i.MX6 SoC.
Please take a look and give me some comments.

Many Thanks,
Paul

Ying-Chun Liu (PaulLiu) (1):
  Regulator: Add Anatop regulator driver

 drivers/regulator/Kconfig                  |    7 +
 drivers/regulator/Makefile                 |    1 +
 drivers/regulator/anatop-regulator.c       |  236 ++++++++++++++++++++++++++++
 include/linux/regulator/anatop-regulator.h |   82 ++++++++++
 4 files changed, 326 insertions(+), 0 deletions(-)
 create mode 100644 drivers/regulator/anatop-regulator.c
 create mode 100644 include/linux/regulator/anatop-regulator.h

-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2HEQcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:32:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2HEQcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:32:45 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Date: Mon,  6 Aug 2012 00:32:48 +0800
Message-Id: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since IORESOURCE_IO is used for PCI devices, it doesn't fit on
88PM860x PMIC device that lies on I2C bus. So use IORESOURCE_MEM
instead.


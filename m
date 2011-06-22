Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1FVGBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 02:01:49 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53389 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVGBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 02:01:47 -0400
From: Sangbeom Kim <sbkim73@samsung.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] S5M8751 core driver
Date: Wed, 22 Jun 2011 14:53:54 +0900
Message-Id: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements core support for the S5M8751 PMIC.
Since the S5M8751 includes regulator, bettery charger, Audio DAC,
which need be represented via the relevant subsystems
for integration with the rest of the kernel a MFD core device is
provided to manage chip access.
The each part of the driver will be submitted separately
via the relevant subsystems.

[PATCH 1/3] mfd: Add S5M8751 register definitions
[PATCH 2/3] mfd: Add initial S5M8751 support
[PATCH 3/3] mfd: Add I2C control support for S5M8751

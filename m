Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1L0TKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 14:10:22 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:44424 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1L0TKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 14:10:20 -0500
From: Sangbeom Kim <sbkim73@samsung.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/1] regulator: Support S5M8767A
Date: Tue, 27 Dec 2011 16:36:25 +0900
Message-Id: <1324971386-4447-1-git-send-email-sbkim73@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following patch will add S5M8767A PMIC driver for mobile application.
S5M8767A is is a cost-effective PMIC and high efficiecy pmic.
It includes 9 Buck and 28 LDOs. and It is optimized to use for multi-core SOCs.

This is 3rd patch.
As Mark Brown comments, Change the patch like below.

Change since v2:
- Implement get_voltage_sel
- Implement set_voltage_time_sel
- replace kzalloc with devm_kzalloc
- fix identation error

Thanks,


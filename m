Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab2CLIbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 04:31:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36943 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2CLIbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 04:31:20 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-d3-4f5db4560540
Message-id: <4F5DB455.1080907@samsung.com>
Date: Mon, 12 Mar 2012 17:31:17 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: [PATCH v3 0/2] input: add MAX8997-haptic driver
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 has several features in a single chip,
This patchset supports unimplemented haptic driver of MAX8997.

This patchset tested on TRATS board based on EXYNOS4210.

v2
- code clean and remove unnecessary code according to comment of Dmitry
Torokhov

v3
- use work_struct to enable/disable max8997-haptic instead of using mutex
  in irq handler statck of forced feedbacky

Donggeun Kim (2):
  mfd: add platform data for MAX8997 haptic driver
  input: add driver support for MAX8997-haptic

 drivers/input/misc/Kconfig          |   12 +
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/max8997_haptic.c |  377
+++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h         |   53 +++++-
 4 files changed, 442 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/max8997_haptic.c

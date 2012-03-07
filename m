Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab2CGIDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 03:03:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:65123 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2CGIC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 03:02:58 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-63-4f5716311963
Message-id: <4F571629.8010203@samsung.com>
Date: Wed, 07 Mar 2012 17:02:49 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com
Subject: [PATCH v2 0/2] input: add MAX8997-haptic driver
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 has several features in a single chip,
This patchset supports unimplemented haptic driver of MAX8997.

v2
- code clean and remove unnecessary code according to comment of Dmitry
Torokhov

Donggeun Kim (2):
  mfd: add platform data for MAX8997 haptic driver
  input: add driver support for MAX8997-haptic

 drivers/input/misc/Kconfig          |   12 ++
 drivers/input/misc/Makefile         |    1 +
 drivers/input/misc/max8997_haptic.c |  371
+++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997.h         |   53 +++++-
 4 files changed, 436 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/max8997_haptic.c

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2JIESG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 00:18:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44166 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab2JIESC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 00:18:02 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20mfd=3A=20da9055=3A=20Remove=20unprintable=20characters=20from=20headers?=
Date: Mon,  8 Oct 2012 10:59:52 +0900
Message-Id: <1349661592-25234-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seem to be a number of unprintable characters at the head of some
of the DA9055 include files which cause issues with some tools; remove
them.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/mfd/da9055/core.h  |    2 +-
 include/linux/mfd/da9055/pdata.h |    2 +-
 include/linux/mfd/da9055/reg.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/da9055/core.h b/include/linux/mfd/da9055/core.h
index c96ad68..956afa4 100644
--- a/include/linux/mfd/da9055/core.h
+++ b/include/linux/mfd/da9055/core.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * da9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
diff --git a/include/linux/mfd/da9055/pdata.h b/include/linux/mfd/da9055/pdata.h
index 147293b..b9b204e 100644
--- a/include/linux/mfd/da9055/pdata.h
+++ b/include/linux/mfd/da9055/pdata.h
@@ -1,4 +1,4 @@
-﻿/* Copyright (C) 2012 Dialog Semiconductor Ltd.
+/* Copyright (C) 2012 Dialog Semiconductor Ltd.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/linux/mfd/da9055/reg.h b/include/linux/mfd/da9055/reg.h
index df237ee..2b592e0 100644
--- a/include/linux/mfd/da9055/reg.h
+++ b/include/linux/mfd/da9055/reg.h
@@ -1,4 +1,4 @@
-﻿/*
+/*
  * DA9055 declarations for DA9055 PMICs.
  *
  * Copyright(c) 2012 Dialog Semiconductor Ltd.
-- 
1.7.10.4


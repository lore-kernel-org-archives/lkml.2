Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2J3Hqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:46:38 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34755 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2J3Hqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:46:37 -0400
Date: Tue, 30 Oct 2012 00:46:33 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: DA9055 - fix broken UTF-8 encoding in sources
Message-ID: <20121030074632.GA12005@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this changes sparse barfs when trying to check DA9055 code.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 include/linux/mfd/da9055/core.h  | 2 +-
 include/linux/mfd/da9055/pdata.h | 2 +-
 include/linux/mfd/da9055/reg.h   | 2 +-
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
1.7.11.7


-- 
Dmitry

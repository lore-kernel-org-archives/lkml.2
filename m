Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0LUXaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 18:30:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55294 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753464Ab0LUXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 18:30:09 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Make regulator_has_full_constraints a bool
Date: Tue, 21 Dec 2010 23:30:07 +0000
Message-Id: <1292974207-31736-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a boolean value so use the type.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 911b774..6066a8f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -44,7 +44,7 @@
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
-static int has_full_constraints;
+static bool has_full_constraints;
 static bool board_wants_dummy_regulator;
 
 /*
-- 
1.5.4.3


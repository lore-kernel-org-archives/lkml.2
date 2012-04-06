Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab2DFA35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:29:57 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58669 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2DFA34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:29:56 -0400
Message-ID: <1333672189.2777.7.camel@phoenix>
Subject: [PATCH 4/6] regulator: max8952: Constify regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Fri, 06 Apr 2012 08:29:49 +0800
In-Reply-To: <1333671867.2777.2.camel@phoenix>
References: <1333671867.2777.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8952.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index c35236a..b408431 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -159,7 +159,7 @@ static struct regulator_ops max8952_ops = {
 	.set_suspend_disable	= max8952_disable,
 };
 
-static struct regulator_desc regulator = {
+static const struct regulator_desc regulator = {
 	.name		= "MAX8952_VOUT",
 	.id		= 0,
 	.n_voltages	= MAX8952_NUM_DVS_MODE,
-- 
1.7.5.4




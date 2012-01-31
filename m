Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2AaGoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 01:44:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62595 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2AaGow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 01:44:52 -0500
Message-ID: <1327992241.9257.1.camel@phoenix>
Subject: [PATCH] Documentation: devres: add devm_regulator_* to the list of
 managed interfaces
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Tejun Heo <tj@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-doc@vger.kernel.org
Date: Tue, 31 Jan 2012 14:44:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devm_regulator_put() and devm_regulator_bulk_get() to the list of managed
interfaces.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 Documentation/driver-model/devres.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index b49829e..2a596a4 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -274,3 +274,5 @@ IOMAP
 
 REGULATOR
   devm_regulator_get()
+  devm_regulator_put()
+  devm_regulator_bulk_get()
-- 
1.7.5.4




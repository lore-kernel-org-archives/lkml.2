Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0IKTW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 15:22:26 -0400
Received: from mail.perches.com ([173.55.12.10]:1692 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab0IKTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 15:22:25 -0400
Subject: [PATCH] Documentation/SubmittingPatches: Add and describe
 scripts/get_maintainer.pl
From: Joe Perches <joe@perches.com>
To: Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20100911120243.7cce451e@schatten.dmk.lab>
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
	 <1284111767.1783.35.camel@Joe-Laptop>
	 <20100910095259.GC23903@sirena.org.uk>
	 <1284113066.1783.69.camel@Joe-Laptop>
	 <20100910101818.GF3068@rakim.wolfsonmicro.main>
	 <1284115665.1783.144.camel@Joe-Laptop>
	 <1284164541.1783.204.camel@Joe-Laptop>
	 <20100911113811.7c685c6d@schatten.dmk.lab>
	 <1284198750.12180.18.camel@Joe-Laptop>
	 <20100911120243.7cce451e@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Sep 2010 12:22:23 -0700
Message-ID: <1284232943.12180.97.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/SubmittingPatches |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 689e237..bb318f9 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -176,6 +176,23 @@ discussed should the patch then be submitted to Linus.
 
 6) Select your CC (e-mail carbon copy) list.
 
+Use
+	"./scripts/get_maintainer.pl --nogit --roles <patch>"
+to find the appropriate maintainers and mailing lists to CC.
+
+If the output email addresses doesn't show a "supporter" or "maintainer",
+you can expand the search to include git history with:
+
+	"./scripts/get_maintainer.pl --roles <patch>"
+
+Searching git history can often list individuals that may not be
+particularly interested in your patch, so use the list of names
+judiciously.
+
+./scripts/get_maintainers.pl options "--rolestats" and "--git-blame"
+can show a bit more information and might help you select the appropriate
+parties to CC.
+
 Unless you have a reason NOT to do so, CC linux-kernel@vger.kernel.org.
 
 Other kernel developers besides Linus need to be aware of your change,



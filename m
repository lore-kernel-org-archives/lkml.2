Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2F0P66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:58:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47847 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930Ab2F0P6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:58:22 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 14/16] UBI: Fastmap: Remove one point from TODO list
Date: Wed, 27 Jun 2012 17:57:54 +0200
Message-Id: <1340812676-14460-15-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340812676-14460-1-git-send-email-richard@nod.at>
References: <1340812676-14460-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

autoresize works too.
It was tested with ubirsvol and ubinize which triggered
an autoresize.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 TODO |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/TODO b/TODO
index b1ae872..7386d3b 100644
--- a/TODO
+++ b/TODO
@@ -6,7 +6,6 @@ to the ubi-utils.git repository, to a separate branch at the beginning
 
 2. Implement power-cut emulation infrastructure similar to what is in UBIFS and
    test UBI + fastmap with it.
-3. Test the autoresize feature
 4. Test 'ubi_flush()'
 5. Test that the same UBI image works fine on both LE and BE machines. I guess
    we can do this using sime kind of emulators?
-- 
1.7.6.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0FXKMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:12:25 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47839 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab0FXKMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:12:23 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>,
       Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] MAINTAINERS: Add an entry for the input MT protocol
Date: Thu, 24 Jun 2010 12:12:01 +0200
Message-Id: <1277374321-19358-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORjPj-0007Zi-Bw.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1ORjPj-0007Zi-Bw d6b64e071f8ec89b28c9d0b7f26ec0cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a maintainer for the input multitouch (MT) protocol,
such that get_maintainer.pl selects it whenever an MT event is present
in the patch.

Cc: Joe Perches <joe@perches.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..603413b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2887,6 +2887,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 
+INPUT MULTITOUCH (MT) PROTOCOL
+M:	Henrik Rydberg <rydberg@euromail.se>
+L:	linux-input@vger.kernel.org
+S:	Maintained
+F:	Documentation/input/multi-touch-protocol.txt
+K:	\b(ABS|SYN)_MT_
+
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
 L:	linux-pm@lists.linux-foundation.org
-- 
1.6.3.3


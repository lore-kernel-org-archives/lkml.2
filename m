Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0FGTO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:14:29 -0400
Received: from mail.perches.com ([173.55.12.10]:2741 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab0FGTO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:14:28 -0400
Subject: [PATCH V2 12/17] MAINTAINERS: Add STAGING - PARALLEL LCD/KEYPAD
 PANEL DRIVER
From: Joe Perches <joe@perches.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel <devel@driverdev.osuosl.org>
In-Reply-To: <20100607185710.GA28465@1wt.eu>
References: <cover.1275935090.git.joe@perches.com>
	 <86ea0af9863474849b1db4981c40b1cd1bed4d74.1275935091.git.joe@perches.com>
	 <20100607185710.GA28465@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 12:14:26 -0700
Message-ID: <1275938066.26425.47.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4494736..33679ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5512,6 +5512,11 @@ M:	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
 S:	Odd Fixes
 F:	drivers/staging/otus/
 
+STAGING - PARALLEL LCD/KEYPAD PANEL DRIVER
+M:	Willy Tarreau <w@1wt.eu>
+S:	Odd Fixes
+F:	drivers/staging/panel/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes
-- 
1.7.1.244.gbdc4




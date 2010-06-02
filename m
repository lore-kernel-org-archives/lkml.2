Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115Ab0FBUIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:08:42 -0400
Received: from mail.perches.com ([173.55.12.10]:2569 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab0FBUIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:08:41 -0400
Subject: [PATCH] MAINTAINERS: Add staging/b.a.t.m.a.n
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: devel <devel@driverdev.osuosl.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100602185323.GA6600@suse.de>
References: <1275498615.23599.12.camel@Joe-Laptop.home>
	 <20100602185323.GA6600@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 13:08:39 -0700
Message-ID: <1275509319.23599.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 11:53 -0700, Greg KH wrote:
> The TODO file in this directory clearly states who to copy on patches to
> these files.

Does anyone look at those? ;)

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2652ebc..e25e15a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5436,6 +5436,14 @@ L:	devel@driverdev.osuosl.org
 S:	Maintained
 F:	drivers/staging/
 
+STAGING B.A.T.M.A.N.
+M:	Marek Lindner <lindner_marek@yahoo.de>
+M:	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
+M:	Andrew Lunn <andrew@lunn.ch>
+L:	b.a.t.m.a.n@lists.open-mesh.net
+S:	Maintained (one day soon)
+F:	drivers/staging/batman-adv/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0FGTLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:11:39 -0400
Received: from mail.perches.com ([173.55.12.10]:2737 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab0FGTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:11:38 -0400
Subject: [PATCH] drivers/staging/otus/TODO: Don't bother, for documentation
 purposes only
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>
In-Reply-To: <20100607190236.GD29505@tux>
References: <cover.1275935090.git.joe@perches.com>
	 <de848b7990a8a691068c8761543a321f4df3f759.1275935091.git.joe@perches.com>
	 <20100607190236.GD29505@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 12:11:35 -0700
Message-ID: <1275937895.26425.41.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 12:02 -0700, Luis R. Rodriguez wrote:
> this driver is unmaintained and its only purpose is as a
> source of documentation for developers working on ar9170 and carl9170.
> Once carl9170 gets 11n support and merged upstream then this driver
> can be removed.

Then the TODO file should be updated.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/otus/TODO |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/otus/TODO b/drivers/staging/otus/TODO
index 4caf026..6fea974 100644
--- a/drivers/staging/otus/TODO
+++ b/drivers/staging/otus/TODO
@@ -2,15 +2,7 @@ I'm hesitant to add a TODO file here, as the wireless developers would
 really have people help them out on the "clean" ar9170 driver that can
 be found at the linux-wireless developer site.
 
-But, if you wish to clean up this driver instead, here's a short list of
-things that need to be done to get it into a more mergable shape:
-
-TODO:
-	- checkpatch.pl cleanups
-	- sparse cleanups
-	- port to in-kernel 80211 stack
-	- review by the wireless developer community
-
-Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
-Luis Rodriguez <Luis.Rodriguez@Atheros.com> and the
-otus-devel@lists.madwifi-project.org mailing list.
+This driver is unmaintained and its only purpose is as a
+source of documentation for developers working on ar9170 and carl9170.
+Once carl9170 gets 11n support and merged upstream then this driver
+can be removed.



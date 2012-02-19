Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab2BSCKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 21:10:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2BSCKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 21:10:47 -0500
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Date: Sun, 19 Feb 2012 13:10:00 +1100
Subject: [PATCH 0/3] Small fixes for w1_bq27000 driver
Cc: GregKH <greg@kroah.com>, Thomas Weber <weber@corscience.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Message-ID: <20120219020910.4958.46866.stgit@notabene.brown>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches fix a problem with the w1 interface for
the bq27000 battery charge meter, and remove some unnecessary code.

thanks,
NeilBrown


---

NeilBrown (3):
      w1_bq27000: Only one thread can access the bq27000 at a time.
      w1_bq27000 - remove w1_bq27000_write
      w1_bq27000: remove unnecessary NULL test.


 drivers/w1/slaves/w1_bq27000.c |   19 ++-----------------
 1 files changed, 2 insertions(+), 17 deletions(-)

-- 
Signature


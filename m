Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab0IZCBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 22:01:11 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:47861 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab0IZCBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 22:01:09 -0400
Date: Sat, 25 Sep 2010 19:05:50 -0700
From: Andres Salomon <dilinger@queued.net>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, cjb@laptop.org, jon.nettleton@gmail.com,
        dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: olpc_dcon: add people to the Cc list
Message-ID: <20100925190550.470370c4@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some additional folks requested to be Cc'd for OLPC-DCON changes; add them
to the TODO file.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/staging/olpc_dcon/TODO |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/olpc_dcon/TODO b/drivers/staging/olpc_dcon/TODO
index 2b75558..ac2d3d0 100644
--- a/drivers/staging/olpc_dcon/TODO
+++ b/drivers/staging/olpc_dcon/TODO
@@ -13,3 +13,5 @@ TODO:
 Please send patches to Greg Kroah-Hartman <greg@kroah.com> and
 copy:
 	Andres Salomon <dilinger@queued.net>
+	Chris Ball <cjb@laptop.org>
+	Jon Nettleton <jon.nettleton@gmail.com>
-- 
1.5.6.5


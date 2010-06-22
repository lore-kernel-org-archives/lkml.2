Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab0FVQEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 12:04:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30933 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0FVQEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:04:11 -0400
Date: Tue, 22 Jun 2010 09:03:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, axboe@kernel.dk
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] block/xd.c: fix brace typo
Message-Id: <20100622090343.d921a70c.randy.dunlap@oracle.com>
In-Reply-To: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
References: <20100622160518.2ef7afcc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4C20DEF4.00FB:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix extra brace typo that is causing build errors.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/xd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100622.orig/drivers/block/xd.c
+++ linux-next-20100622/drivers/block/xd.c
@@ -322,7 +322,7 @@ static void do_xd_request (struct reques
 		int res = -EIO;
 		int retry;
 
-		if (req->cmd_type != REQ_TYPE_FS) {
+		if (req->cmd_type != REQ_TYPE_FS)
 			goto done;
 		if (block + count > get_capacity(req->rq_disk))
 			goto done;

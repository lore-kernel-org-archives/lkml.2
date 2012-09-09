Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2IIXUo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:20:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51557 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756442Ab2IIXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:19 -0400
Message-Id: <20120909224155.912274484@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:27 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "bjschuma@gmail.com" <bjschuma@gmail.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 37/95] NFS: Alias the nfs module to nfs4
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "bjschuma@gmail.com" <bjschuma@gmail.com>

commit 425e776d93a7a5070b77d4f458a5bab0f924652c upstream.

This allows distros to remove the line from their modprobe
configuration.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -3087,4 +3087,6 @@ static struct dentry *nfs4_referral_moun
 	return res;
 }
 
+MODULE_ALIAS("nfs4");
+
 #endif /* CONFIG_NFS_V4 */



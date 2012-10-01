Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2JAX2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:28:42 -0400
Received: from 1wt.eu ([62.212.114.60]:35236 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757575Ab2JAXAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:48 -0400
Message-Id: <20121001225203.121723717@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 130/180] NFS: Alias the nfs module to nfs4
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: bjschuma@gmail.com <bjschuma@gmail.com>

commit 425e776d93a7a5070b77d4f458a5bab0f924652c upstream.

This allows distros to remove the line from their modprobe
configuration.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index c346808..9a3f15b 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2934,4 +2934,6 @@ out:
 	return error;
 }
 
+MODULE_ALIAS("nfs4");
+
 #endif /* CONFIG_NFS_V4 */
-- 
1.7.2.1.45.g54fbc




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2ILXdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:33:09 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49817 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2ILXdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:33:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Bryan Schumaker <bjschuma@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 042/108] NFS: Alias the nfs module to nfs4
Date: Wed, 12 Sep 2012 16:28:40 -0700
Message-Id: <20120912232454.947953753@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

commit 425e776d93a7a5070b77d4f458a5bab0f924652c upstream.

This allows distros to remove the line from their modprobe
configuration.

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2961,4 +2961,6 @@ static struct dentry *nfs4_referral_moun
 	return res;
 }
 
+MODULE_ALIAS("nfs4");
+
 #endif /* CONFIG_NFS_V4 */



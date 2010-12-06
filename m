Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0LFWHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:48 -0500
Received: from mail.perches.com ([173.55.12.10]:2336 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/29] fs/nfsd: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:06 -0800
Message-Id: <4f25a1ab06caf6f4994b9783727b96d99c7c8d6c.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing 1 as first argument.
Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/nfsd/nfs4state.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4d542cf..7abd980 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1241,7 +1241,8 @@ nfsd4_store_cache_entry(struct nfsd4_compoundres *resp)
 					(char *)resp->xbuf->head[0].iov_base;
 	if (read_bytes_from_xdr_buf(resp->xbuf, base, slot->sl_data,
 				    slot->sl_datalen))
-		WARN("%s: sessions DRC could not cache compound\n", __func__);
+		WARN(1, "%s: sessions DRC could not cache compound\n",
+		     __func__);
 	return;
 }
 
-- 
1.7.3.2.245.g03276.dirty


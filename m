Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2JBKTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:19:02 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4322 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab2JBKTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:19:00 -0400
Subject: [PATCH 5/5] nfs: include internah.h in getroot.h
To: Trond.Myklebust@netapp.com
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, devel@openvz.org,
        linux-kernel@vger.kernel.org, jlayton@redhat.com
Date: Tue, 02 Oct 2012 14:19:14 +0400
Message-ID: <20121002101914.15507.39303.stgit@localhost.localdomain>
In-Reply-To: <20121002101649.15507.50466.stgit@localhost.localdomain>
References: <20121002101649.15507.50466.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warning:
fs/nfs/nfs4getroot.c:11:5: warning: symbol 'nfs4_get_rootfh' was not declared.
Should it be static?

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 fs/nfs/getroot.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index 4654ced..033803c 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -32,6 +32,8 @@
 
 #include <asm/uaccess.h>
 
+#include "internal.h"
+
 #define NFSDBG_FACILITY		NFSDBG_CLIENT
 
 /*


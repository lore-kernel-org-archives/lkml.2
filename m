Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2ISQG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:06:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:23280 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab2ISQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:06:27 -0400
Subject: [PATCH v5 01/10] ipc: remove forced assignment of selected message
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, netdev@vger.kernel.org,
        will.deacon@arm.com, linux-kernel@vger.kernel.org, cmetcalf@tilera.com,
        jmorris@namei.org, linux-driver@qlogic.com,
        linux-security-module@vger.kernel.org, hughd@google.com,
        ron.mercer@qlogic.com, viro@zeniv.linux.org.uk,
        james.l.morris@oracle.com, catalin.marinas@arm.com,
        casey@schaufler-ca.com, eparis@parisplace.org, sds@tycho.nsa.gov,
        jitendra.kalsaria@qlogic.com, devel@openvz.org
Date: Wed, 19 Sep 2012 20:05:31 +0400
Message-ID: <20120919160531.11254.48182.stgit@localhost6.localdomain6>
In-Reply-To: <20120919160430.11254.86848.stgit@localhost6.localdomain6>
References: <20120919160430.11254.86848.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cleanup patch. The assignment is redundant.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 7385de2..f3bfbb8 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -787,7 +787,6 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
 			    !security_msg_queue_msgrcv(msq, walk_msg, current,
 						       msgtyp, mode)) {
 
-				msg = walk_msg;
 				if (mode == SEARCH_LESSEQUAL &&
 						walk_msg->m_type != 1) {
 					msg = walk_msg;


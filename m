Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0JARH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:07:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:45963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab0JARH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,267,1283756400"; 
   d="scan'208";a="331028660"
From: John Fastabend <john.r.fastabend@intel.com>
Subject: [PATCH] selinux: add dcbnl netlink messages to selinux
To: jmorris@namei.com
Cc: john.r.fastabend@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 01 Oct 2010 10:07:50 -0700
Message-ID: <20101001170750.20327.16643.stgit@jf-dev1-dcblab>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DCBNL netlink msg support to selinux. Without this
'unrecognized netlink message' warnings may be seen.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
---

 security/selinux/nlmsgtab.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 75ec0c6..8b02b21 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -65,6 +65,8 @@ static struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETADDRLABEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETDCB,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static struct nlmsg_perm nlmsg_firewall_perms[] =


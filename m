Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0EQCJ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 22:09:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39557 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab0EQCJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 22:09:27 -0400
Date: Mon, 17 May 2010 12:09:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@medozas.de>, Chris Wright <chrisw@sous-sol.org>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20100517120922.50d5e0fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
include/linux/if_link.h between commit
c02db8c6290bb992442fec1407643c94cc414375 ("rtnetlink: make SR-IOV VF
interface symmetric") from Linus' tree and commit
10708f37ae729baba9b67bd134c3720709d4ae62 ("net: core: add IFLA_STATS64
support") from the net tree.

Just context changes.  I fixed it up (see below) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/if_link.h
index d94963b,cfd420b..0000000
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@@ -79,7 -111,11 +111,8 @@@ enum 
  	IFLA_NET_NS_PID,
  	IFLA_IFALIAS,
  	IFLA_NUM_VF,		/* Number of VFs if device is SR-IOV PF */
 -	IFLA_VF_MAC,		/* Hardware queue specific attributes */
 -	IFLA_VF_VLAN,
 -	IFLA_VF_TX_RATE,	/* TX Bandwidth Allocation */
 -	IFLA_VFINFO,
 +	IFLA_VFINFO_LIST,
+ 	IFLA_STATS64,
  	__IFLA_MAX
  };
  

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0IKFqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:46:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0IKFp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dMmb/+riE/W7OTMkexRD0FPU9JEMiIBhh7vwIpbZTd988hf9HyGs73lzrqNzfex+07
         Zo773N/HnJVON5F/r44InjCW0LFHY6eKx4yQH+Nq2I+9VGOKmRh3REhMe3zP1txNkVHR
         lWPAGOX9dtzWWNRmQkBx2En/N65Fza/QIdo9M=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/11]net/netfilter/nf_conntrack_proto_tcp.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:46:03 -0700
Message-Id: <1284183963-8474-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c4c885d..a695842 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -329,8 +329,8 @@ static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 /* TCP connection tracking based on 'Real Stateful TCP Packet Filtering
    in IP Filter' by Guido van Rooij.
 
-   http://www.nluug.nl/events/sane2000/papers.html
-   http://www.iae.nl/users/guido/papers/tcp_filtering.ps.gz
+   http://www.sane.nl/events/sane2000/papers.html 
+   http://www.darkart.com/mirrors/www.obfuscation.org/ipf/
 
    The boundaries and the conditions are changed according to RFC793:
    the packet must intersect the window (i.e. segments may be
-- 
1.7.2.1


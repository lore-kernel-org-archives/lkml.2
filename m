Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0IKFpy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0IKFpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KzcvSuVXbd6CuId82cCZCEqCRa9Md/hIFewhIh1Qjbf17JrOLjhBG2bBzs/hSl7kRe
         kmvsxb6+wVLnPBv5Cnoc1LHbVMeNMRFconzuWtxZQzfWIsS40Yq0rPOh2iYDOchwted8
         EgV8nQxw7sqKeaRQSGGShfc9OF0afAGPlfewM=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 08/11]net/ipv4/tcp_input.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:46:00 -0700
Message-Id: <1284183963-8474-8-git-send-email-justinmattock@gmail.com>
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
 net/ipv4/tcp_input.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e663b78..f5b7628 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -428,10 +428,10 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
  *
  * The algorithm for RTT estimation w/o timestamps is based on
  * Dynamic Right-Sizing (DRS) by Wu Feng and Mike Fisk of LANL.
- * <http://www.lanl.gov/radiant/website/pubs/drs/lacsi2001.ps>
+ * <http://public.lanl.gov/radiant/pubs.htm>
  *
  * More detail on this code can be found at
- * <http://www.psc.edu/~jheffner/senior_thesis.ps>,
+ * <http://staff.psc.edu/jheffner/>,
  * though this reference is out of date.  A new paper
  * is pending.
  */
-- 
1.7.2.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2IYXbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 19:31:32 -0400
Received: from nm12-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.242]:22989 "HELO
	nm12-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752632Ab2IYXb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 19:31:26 -0400
X-Yahoo-Newman-Id: 379983.256.bm@omp1030.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: c5azbLsVM1kT70vh.MBejP.Bdf8azQC.cHGnKUWxXO6svN8
 vb.9u498q.yCBV.JkH3Cw6SVQ0pZW2QrJd4qrYtJxolbvHOFJfdS9E.BTBTt
 fBmnN7umoKZ_aGCtEOL65WFHIpCHK0uP0PBjnpE1r.gvWaXs1TRKhJHLGDRO
 dhmskEwID7uk_1vnElBQnLALYRi74w6CW7.p_.jWF2UOAPt3t296Icdrc8R7
 uLmdM2R5LWkCwXMbMDVi4.KZaZ_sEzxhJCnly.3MbDmFwXm.now2V3P4gjjs
 xal.1cI1EpxsiES.rSXr5CObBWuHiGGPv.JL2mfOP5Ya6mUZ80L4y4xx6URj
 D5jYhJW.PT_99mjwV7VWbwzWi0vhM5GDOgDR69w6m_j_loEk_RaqdotvyoUx
 84Xp97toYywNuv2E58eeu4FESDLSJeEyD77RiZD7QNE4u2bTli_s5
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: Daniel Santos <daniel.santos@pobox.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Subject: [PATCH v5 12/25] rbtree.h: include kconfig.h
Date: Tue, 25 Sep 2012 18:31:19 -0500
Message-Id: <1348615879-10359-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
References: <1348615467-9850-1-git-send-email-daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't depend upon kernel.h including this for us.  However, this
also fixes some issues with compiling in userland (coming later).

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 include/linux/rbtree.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index f1b53d5..66a99fd 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -98,6 +98,7 @@ static inline struct page * rb_insert_page_cache(struct inode * inode,
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/bug.h>
+#include <linux/kconfig.h>
 
 struct rb_node
 {
-- 
1.7.3.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab0EGIrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:47:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab0EGIri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:47:38 -0400
Message-ID: <4BE3D3A1.90707@cn.fujitsu.com>
Date: Fri, 07 May 2010 16:47:29 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: update document of gfns
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When don't use ->gfns when role.direct=1, update document for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Requested-by: Avi Kivity <avi@redhat.com>
---
diff --git a/Documentation/kvm/mmu.txt b/Documentation/kvm/mmu.txt
index da04671..aec19ae 100644
--- a/Documentation/kvm/mmu.txt
+++ b/Documentation/kvm/mmu.txt
@@ -178,7 +178,9 @@ Shadow pages contain the following information:
     guest pages as leaves.
   gfns:
     An array of 512 guest frame numbers, one for each present pte.  Used to
-    perform a reverse map from a pte to a gfn.
+    perform a reverse map from a pte to a gfn. When role.direct is set, any
+    element of this array can be calculated from the gfn field when used, in
+    this case, the array of gfns is not allocated. See role.direct and gfn.
   slot_bitmap:
     A bitmap containing one bit per memory slot.  If the page contains a pte
     mapping a page from memory slot n, then bit n of slot_bitmap will be set


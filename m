Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2I1PHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:07:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8646 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab2I1PHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:07:02 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>
Subject: [PATCH v2 0/3] move slabinfo processing to common code
Date: Fri, 28 Sep 2012 19:03:25 +0400
Message-Id: <1348844608-12568-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch moves on with the slab caches commonization, by moving
the slabinfo processing to common code in slab_common.c. It only touches
slub and slab, since slob doesn't create that file, which is protected
by a Kconfig switch.

Enjoy,

v2: return objects per slab and cache order in slabinfo structure as well

Glauber Costa (3):
  move slabinfo processing to slab_common.c
  move print_slabinfo_header to slab_common.c
  sl[au]b: process slabinfo_show in common code

 mm/slab.c        | 118 ++++++++++++-------------------------------------------
 mm/slab.h        |  20 ++++++++++
 mm/slab_common.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c        |  77 ++++++------------------------------
 4 files changed, 166 insertions(+), 158 deletions(-)

-- 
1.7.11.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab1HDOie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:38:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44618 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1HDOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:38:33 -0400
MIME-Version: 1.0
Date: Thu, 4 Aug 2011 22:38:31 +0800
Message-ID: <CAJd=RBA9ihp94TtjkWbAVo1Y_2+Vp1VskJWVahN85biCEAYWtQ@mail.gmail.com>
Subject: [RFC patch] MIPS: select correct tc
From: Hillf Danton <dhillf@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we could find tc on the tc list for @index, the found tc should be returned.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/kernel/vpe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index dbb6b40..044b700 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -192,7 +192,7 @@ static struct tc *get_tc(int index)
 	}
 	spin_unlock(&vpecontrol.tc_list_lock);

-	return NULL;
+	return res;
 }

 /* allocate a vpe and associate it with this minor (or index) */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0JHSc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:32:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:36785 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab0JHSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:32:58 -0400
Date: Fri, 8 Oct 2010 11:34:24 -0700
From: Andres Salomon <dilinger@queued.net>
To: grant.likely@secretlab.ca
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] sparc: stop exporting openprom.h header
Message-ID: <20101008113424.2249c2df@debxo>
In-Reply-To: <20101008.104557.59696706.davem@davemloft.net>
References: <20101008171210.GE3863@angua.secretlab.ca>
	<20101008.101759.193728130.davem@davemloft.net>
	<20101008173650.GH3863@angua.secretlab.ca>
	<20101008.104557.59696706.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's unknown why openprom.h was being exported; there doesn't seem to be any
reason for it currently, and it creates headaches with userspace being able
to potentially use the structures in there.  So, don't export it anymore.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/sparc/include/asm/Kbuild |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index deeb0fb..3c93f08 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -7,7 +7,6 @@ header-y += display7seg.h
 header-y += envctrl.h
 header-y += fbio.h
 header-y += jsflash.h
-header-y += openprom.h
 header-y += openpromio.h
 header-y += perfctr.h
 header-y += psrcompat.h
-- 
1.5.6.5


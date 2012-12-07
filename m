Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2LGOhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:37:38 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:59641
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788Ab2LGOhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:37:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <rob@landley.net>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>, Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH] HOWTO: fix double words typo
Date: Fri, 7 Dec 2012 16:37:11 +0200
Message-ID: <1354891031-4924-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 Documentation/HOWTO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 59c080f..a9f288f 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -462,7 +462,7 @@ Differences between the kernel community and corporate structures
 
 The kernel community works differently than most traditional corporate
 development environments.  Here are a list of things that you can try to
-do to try to avoid problems:
+do to avoid problems:
   Good things to say regarding your proposed changes:
     - "This solves multiple problems."
     - "This deletes 2000 lines of code."
-- 
1.7.8.6



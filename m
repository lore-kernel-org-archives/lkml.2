Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647Ab2J2WUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:20:03 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9959 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048Ab2J2WT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:19:58 -0400
Message-ID: <1351549194.2757.26.camel@lorien2>
Subject: [PATCH] Documentation/DMA-API-HOWTO.txt - minor grammar corrections
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Jesper Juhl <jj@chaosbits.net>, rob@landley.net
Cc: Andrew Morton <akpm@linux-foundation.org>, konrad.wilk@oracle.com,
        LKML <linux-kernel@vger.kernel.org>, Shuah Khan <shuah.khan@hp.com>,
        linux-doc@vger.kernel.org
Date: Mon, 29 Oct 2012 16:19:54 -0600
In-Reply-To: <alpine.LNX.2.00.1210292103260.4401@swampdragon.chaosbits.net>
References: <20121029194930.2491B5C0050@hpza9.eem.corp.google.com>
	 <alpine.LNX.2.00.1210292103260.4401@swampdragon.chaosbits.net>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor grammar corrections.

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 Documentation/DMA-API-HOWTO.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index bf242bbe..14129f1 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -488,9 +488,10 @@ will invoke the generic mapping error check interface. Doing so will ensure
 that the mapping code will work correctly on all dma implementations without
 any dependency on the specifics of the underlying implementation. Using the
 returned address without checking for errors could result in failures ranging
-from panics to silent data corruption. Couple of example of incorrect ways to
-check for errors that make assumptions about the underlying dma implementation
-are as follows and these are applicable to dma_map_page() as well.
+from panics to silent data corruption. A couple of examples of incorrect ways
+to check for errors that make assumptions about the underlying dma
+implementation are as follows and these are applicable to dma_map_page() as
+well.
 
 Incorrect example 1:
 	dma_addr_t dma_handle;
-- 
1.7.9.5




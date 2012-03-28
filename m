Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2C1GnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:43:00 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:49140 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916Ab2C1Gm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:42:58 -0400
Date: Wed, 28 Mar 2012 08:42:34 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/3] padata: Add a reference to the api documentation
Message-ID: <20120328064234.GE16191@secunet.com>
References: <20120328064157.GD16191@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328064157.GD16191@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 28 Mar 2012 06:42:34.0999 (UTC) FILETIME=[F56C1870:01CD0CAD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a reference to the padata api documentation at Documentation/padata.txt

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 6f10eb2..7875088 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1,6 +1,8 @@
 /*
  * padata.c - generic interface to process data streams in parallel
  *
+ * See Documentation/padata.txt for an api documentation.
+ *
  * Copyright (C) 2008, 2009 secunet Security Networks AG
  * Copyright (C) 2008, 2009 Steffen Klassert <steffen.klassert@secunet.com>
  *
-- 
1.7.0.4


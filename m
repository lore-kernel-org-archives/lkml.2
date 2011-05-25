Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab1EYMM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:12:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38001 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab1EYMM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HVx8p9PRDOu8oP00RIUChq7o+d4QHBlxudOjzFVHn1lPfvFI43RSgIRKT/CevWzDpW
         wiQnqyKtOozIpkCVthCHWJo6xRTdrcwecuWmHFPQ2AsQ+W/YyeA+N/557taG2Wl4dJ48
         BeXdLV6fuTrzpS1W3lMvGNcWd74OL/XT0pf78=
From: Sasha Levin <levinsasha928@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>
Subject: [PATCH trivial] hwrng: Fix spelling mistake in header
Date: Wed, 25 May 2011 15:12:20 +0300
Message-Id: <1306325540-17934-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/hw_random.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/hw_random.h b/include/linux/hw_random.h
index 9bede76..b4b0eef 100644
--- a/include/linux/hw_random.h
+++ b/include/linux/hw_random.h
@@ -25,7 +25,7 @@
  *			there is always data available.  *OBSOLETE*
  * @data_read:		Read data from the RNG device.
  *			Returns the number of lower random bytes in "data".
- *			Must not be NULL.    *OSOLETE*
+ *			Must not be NULL.    *OBSOLETE*
  * @read:		New API. drivers can fill up to max bytes of data
  *			into the buffer. The buffer is aligned for any type.
  * @priv:		Private data, for use by the RNG driver.
-- 
1.7.5.rc3


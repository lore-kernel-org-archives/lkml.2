Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab0FGTm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 15:42:58 -0400
Received: from mail.perches.com ([173.55.12.10]:2746 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0FGTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 15:42:56 -0400
Subject: [PATCH V2 09/17] MAINTAINERS: Add STAGING - INDUSTRIAL IO
From: Joe Perches <joe@perches.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
In-Reply-To: <4C0D3FFB.7040704@cam.ac.uk>
References: <cover.1275935090.git.joe@perches.com>
	 <81391f52a009e825f5a3bfd73a71ba24190d6f3b.1275935091.git.joe@perches.com>
	 <4C0D3FFB.7040704@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 12:42:54 -0700
Message-ID: <1275939774.26425.78.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 MAINTAINERS |    6 +++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 71e6fe3..680d602 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5497,6 +5497,12 @@ M:	Haiyang Zhang <haiyangz@microsoft.com>
 S:	Odd Fixes
 F:	drivers/staging/hv/
 
+STAGING - INDUSTRIAL IO
+M:	Jonathan Cameron <jic23@cam.ac.uk>
+L:	linux-iio@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/staging/iio/
+
 STARFIRE/DURALAN NETWORK DRIVER
 M:	Ion Badulescu <ionut@badula.org>
 S:	Odd Fixes



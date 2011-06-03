Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab1FCTVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:21:33 -0400
Received: from mail.perches.com ([173.55.12.10]:2483 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1FCTVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:21:32 -0400
Subject: [PATCH] MAINTAINERS: RDS - Remove Andy Grover
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, rds-devel <rds-devel@oss.oracle.com>
In-Reply-To: <BANLkTikg68CHLqYtzk6XDDctBwdJBcXXYQ@mail.gmail.com>
References: <1307069438.14598.16.camel@Joe-Laptop>
	 <20110602.221053.1101725115151286142.davem@davemloft.net>
	 <1307083244.14598.24.camel@Joe-Laptop>
	 <BANLkTikg68CHLqYtzk6XDDctBwdJBcXXYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Jun 2011 12:21:30 -0700
Message-ID: <1307128890.14598.35.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Grover is no longer maintaining RDS.

Signed-off-by: Joe Perches <joe@perches.com>

---

On Fri, 2011-06-03 at 10:44 -0700, Andrew Grover wrote:
> I switched jobs and no longer maintain RDS.
> Regards -- Andy

 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 85e04b6..9e3a655 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5275,7 +5275,6 @@ S:	Maintained
 F:	drivers/net/r6040.c
 
 RDS - RELIABLE DATAGRAM SOCKETS
-M:	Andy Grover <andy.grover@oracle.com>
 L:	rds-devel@oss.oracle.com (moderated for non-subscribers)
 S:	Supported
 F:	net/rds/



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1CRQYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:24:50 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:51303 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756284Ab1CRQYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:24:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=mav53efbwIAFDMJV2tN6zWodZfb+SEYoHYKJoPXydRbHGd1nBWl9a41CkRBpGk8Zs+taAbOqVSaorrqs56U0Dob+bmLUVY7E7jaIt2quOsMx6n/G4BmOVsckLl9eUSIh;
Date: Fri, 18 Mar 2011 09:24:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Cc: gregkh <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH] MAINTAINERS: update STABLE BRANCH info
Message-Id: <20110318092443.e3ddcd67.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Drop Chris Wright from STABLE maintainers.  He hasn't done STABLE
release work for quite some time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

Greg, is there a git tree or quilt queue that people can look at
for stable?

--- linux-next-20110317.orig/MAINTAINERS
+++ linux-next-20110317/MAINTAINERS
@@ -5986,7 +5986,6 @@ F:	arch/alpha/kernel/srm_env.c
 
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
-M:	Chris Wright <chrisw@sous-sol.org>
 L:	stable@kernel.org
 S:	Maintained
 

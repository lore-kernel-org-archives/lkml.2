Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab1EJCu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 22:50:57 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:40445 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1EJCuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 22:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=WI6QUgYaIHyV11M0kX30rSxAsk04m0P5pFsM57FBH7at40NAufv0oANm2MxvRaSvO2
         ZisjoVIiE0z/DQzjg+y8/M6UE+y6m86kwWGTF+iUuzh22JzfJk83/clkt2/ZdjuIEUR3
         l+lscogTzIobR6dQnEphtsjvzCiFEbGIpxpLc=
Date: Tue, 10 May 2011 10:50:32 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org, greg@kroah.com,
        joe@perches.com, randy.dunlap@oracle.com, akpm@linux-foundation.org
Subject: [PATCH]Add Maintainer for MAINTAINERS file for us
Message-ID: <20110510025024.GA2575@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
	linux-doc@vger.kernel.org, greg@kroah.com, joe@perches.com,
	randy.dunlap@oracle.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harry Wei <harryxiyou@gmail.com>

As our kernel is bigger and bigger, maintainers are more and more.
Maintainers add themselves into the MAINTAINERS file, which may add
without alphabetical order. This may be harmful to our management.
I'd like to maintain this file for us. The patch is below.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 16a5c5f..af39897 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2197,10 +2197,12 @@ F:	drivers/acpi/dock.c
 
 DOCUMENTATION
 M:	Randy Dunlap <rdunlap@xenotime.net>
+M:	Harry Wei <harryxiyou@gmail.com>
 L:	linux-doc@vger.kernel.org
 T:	quilt oss.oracle.com/~rdunlap/kernel-doc-patches/current/
 S:	Maintained
 F:	Documentation/
+F:	MAINTAINERS
 
 DOUBLETALK DRIVER
 M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0IPVJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:09:31 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33810 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0IPVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xJgRkJn800K+G47yfZNEqlX4Su+ewUfCOf7ZTPdftjkrmYl2luhIVOsYIgvYmmDy/+
         sFssFAJA2EoSkAGfFXfpLX3vvPgVWHkioU6/ySYlxYVUkcwE5q8CMiqekkDAjfbH4PH3
         /4X25y/wU2O6PH0HrcmAOvUOyQSHQBaBmet0A=
Date: Thu, 16 Sep 2010 17:08:30 -0400
From: Chris Snook <chris.snook@gmail.com>
To: akpm@linux-foundation.org, joe@perches.com, linux-kernel@vger.kernel.org,
        atl1-devel@lists.sourceforge.net, jcliburn@gmail.com,
        jie.yang@atheros.com
Subject: [PATCH] MAINTAINERS: move atlx discussions to netdev
Message-ID: <20100916210830.GB25481@fourier.jnsq.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Snook <chris.snook@gmail.com>

The atlx drivers are sufficiently mature that we no longer need a separate
mailing list for them.  Move the discussion to netdev, so we can decommission
atl1-devel, which is now mostly spam.

Signed-off-by: Chris Snook <chris.snook@gmail.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e7c528f..8e904c8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1135,7 +1135,7 @@ ATLX ETHERNET DRIVERS
 M:	Jay Cliburn <jcliburn@gmail.com>
 M:	Chris Snook <chris.snook@gmail.com>
 M:	Jie Yang <jie.yang@atheros.com>
-L:	atl1-devel@lists.sourceforge.net
+L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/atl1
 W:	http://atl1.sourceforge.net
 S:	Maintained


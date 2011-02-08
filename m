Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab1BHChw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:37:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56987 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab1BHChv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:37:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=GfsozKUiompYuapl1K4hJx8qHEZhou2V5SmcrhNmeHU4R7qqNFJrp4M7DKg4uy/imk
         ujgLu55GzJA7A0ottTvSeRmUjamNmXVOxFL1ebJCE2gbkWtDaraZ3hNiuEdTRUHMLdlu
         JytYnhQZZz8ZLb90Mgsx2MSZ6hcwQa4FtoOxk=
Date: Tue, 8 Feb 2011 10:37:37 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com
Subject: [PATCH]Maintain Chinese Documentations
Message-ID: <20110208023735.GA4599@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, davem@davemloft.net, greg@kroah.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
     I have translated some documentations of kernel so i want to maintain Chinese documentation in our kernel directories.
     Following is my patcher for it.

     Thanks.
     Best Regards.
     Harry Wei.
     
     
Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 531c5cf..dc0279e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6976,6 +6976,12 @@ S:	Maintained
 F:	drivers/net/pptp.c
 W:	http://sourceforge.net/projects/accel-pptp
 
+CHINESE DOCUMENTATION
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+S:	Maintained
+F:	Documentation/zh_CN/
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
1.7.0.4


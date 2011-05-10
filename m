Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1EJKSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 06:18:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39392 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755608Ab1EJKSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 06:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KxoVob3anixCLLjEL8NDFLSY2Kwv8XMOMP6bfzgXQZTIMloOQFydj/b3M/h+kVFwt3
         awcbZmPVk4JOC/oARFf6cfIhhfLYSd8ZSTJCIzx4n4uBnRcSArrAU1hRfF4fHChHJuks
         UHfZu2o+mSVmHmfA2VUjdNsnEVcj5kEeyv1io=
Date: Tue, 10 May 2011 18:17:46 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, greg@kroah.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH]Add Maintainer for MAINTAINERS file for us
Message-ID: <20110510101744.GA4568@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
	akpm@linux-foundation.org, greg@kroah.com,
	linux-doc@vger.kernel.org
References: <20110510025024.GA2575@gmail.com>
 <1304997087.19586.102.camel@Joe-Laptop>
 <20110510045142.GA2888@gmail.com>
 <1305004550.19586.114.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
In-Reply-To: <1305004550.19586.114.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 10:15:50PM -0700, Joe Perches wrote:
> On Tue, 2011-05-10 at 12:51 +0800, Harry Wei wrote:
> > When it is okay, i will patch for kernel.
> 
> I believe that's been done before.
> 
> http://lkml.org/lkml/2011/2/11/330
That's great. I am so sorry i ignored that
patch. I will neaten this patch and take alphabetical 
orders for MAINTAINERS. Then patch for them.
Thanks, Joe ;)
> 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > +MAINTAINERS-FILE
> > +M:	Harry Wei <harryxiyou@gmail.com>
> > +L:	linux-doc@vger.kernel.org
> > +S:	Maintained
> > +F:	MAINTAINERS
> 
> I think using the linux-doc mailing list for
> MAINTAINERS isn't good.
Hmmm, maybe you are right. So i patch below.
I think the default ML, LKML, is okay for
MAINTAINERS file, isn't it?

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a471159..fb771aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4048,6 +4048,12 @@ S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_macvlan.h
 
+MAINTAINERS FILE
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+S:	Maintained
+F:	MAINTAINERS
+
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
 M:	Michael Kerrisk <mtk.manpages@gmail.com>
 W:	http://www.kernel.org/doc/man-pages
-- 
1.7.0.4


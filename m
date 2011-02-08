Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1BHDRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:17:05 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54525 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab1BHDRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:17:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=dydw2yTFKgF97jOEFSRiFINX+B1TFdWI6+HNnpy945NH6OmM+COfPnnN2onPJmKmDB
         4uGONfjtwLTU6+BOjh1304UhhO58/bv7uH1IASHTtUcy5vZ4QaZ4WetYxxSc3B+k2vop
         HDzrrPRjhBWd56a3myLfSe4Qi9CVwqTgUyxHI=
Date: Tue, 8 Feb 2011 11:16:41 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@xenotime.net, davem@davemloft.net,
        joe@perches.com, akpm@linux-foundation.org, greg@kroah.com
Subject: [PATCH]Maintain Chinese Documentations
Message-ID: <20110208031638.GA4828@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, rdunlap@xenotime.net,
	davem@davemloft.net, joe@perches.com, akpm@linux-foundation.org,
	greg@kroah.com
References: <20110208023735.GA4599@gmail.com>
 <20110207184027.468e2a03.rdunlap@xenotime.net>
 <AANLkTimacOStZv-hrxo6iOWUDNem+h1cmaKCZQzw=0jr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimacOStZv-hrxo6iOWUDNem+h1cmaKCZQzw=0jr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 11:10:18AM +0800, harryxiyou wrote:
> ---------- Forwarded message ----------
> From: Randy Dunlap <rdunlap@xenotime.net>
> Date: 2011/2/8
> Subject: Re: [PATCH]Maintain Chinese Documentations
> To: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
> davem@davemloft.net, greg@kroah.com
> 
> 
> On Tue, 8 Feb 2011 10:37:37 +0800 Harry Wei wrote:
> 
> > Hi us,
> >      I have translated some documentations of kernel so i want to maintain
> Chinese documentation in our kernel directories.
> >      Following is my patcher for it.
> >
> >      Thanks.
> >      Best Regards.
> >      Harry Wei.
> >
> >
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > ---
> >  MAINTAINERS |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 531c5cf..dc0279e 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -6976,6 +6976,12 @@ S:     Maintained
> >  F:   drivers/net/pptp.c
> >  W:   http://sourceforge.net/projects/accel-pptp
> >
> > +CHINESE DOCUMENTATION
> > +M:   Harry Wei <harryxiyou@gmail.com>
> > +L:   xiyoulinuxkernelgroup@googlegroups.com
> > +S:   Maintained
> > +F:   Documentation/zh_CN/
> > +
> 
> Hi Harry,
> 
> Entries in the MAINTAINERS file are in alphabetical order, so "CHINESE
> DOCUMENTATION"
> should come between CHECKPATCH and CISCO VIC ETHERNET NIC DRIVER.
Hi Randy,

Thanks so much.
I have patched a right one like following.

Thanks.
Best Regards.
Harry Wei.


Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc0279e..afb6f7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1692,6 +1692,12 @@ M:	Andy Whitcroft <apw@canonical.com>
 S:	Supported
 F:	scripts/checkpatch.pl
 
+CHINESE DOCUMENTATION
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+S:	Maintained
+F:	Documentation/zh_CN
+
 CISCO VIC ETHERNET NIC DRIVER
 M:	Vasanthy Kolluri <vkolluri@cisco.com>
 M:	Roopa Prabhu <roprabhu@cisco.com>
-- 
1.7.0.4

> 
> 
> >  THE REST
> >  M:   Linus Torvalds <torvalds@linux-foundation.org>
> >  L:   linux-kernel@vger.kernel.org
> > --
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!

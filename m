Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab2ADW53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:57:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59543 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab2ADW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:57:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Documentation: Update stable address
Date: Wed, 4 Jan 2012 22:57:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, "Greg Kroah-Hartman" <greg@kroah.com>,
        stable@vger.kernel.org, Harry Wei <harryxiyou@gmail.com>,
        xiyoulinuxkernelgroup@googlegroups.com,
        Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
        linux-kernel@vger.kernel.org
References: <1323468720.27746.42.camel@joe2Laptop> <4F04DFF0.8000006@xenotime.net>
In-Reply-To: <4F04DFF0.8000006@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201042257.15631.arnd@arndb.de>
X-Provags-ID: V02:K0:9hRLtnpDM8m9/YS8n+Zj1a0SwVW5Z89ldM8jv2ZcCwp
 x5nGCbDzUQt9BVLFfc4dfjwHTSxIPauDnxB1Oli4Q5dsoMrXcC
 dq2+R7hGR+vMsiOX/g0XDKmlAY+MpVMtesC9O5kvr2ogCIvSJ/
 kn4b92spXYYagF/XePf2hkI6ueL6u+k8r0zj9DmmcPR1NYA83T
 W4OzJqx9A0J644XRW/jZDbtlp2OAswja+nqFTAqHDLm/y4EaQd
 bjoS53RNV+7zf3ly+AcIxBs9jPrCD88eLcXMcdgcrMsIOQsqlS
 JCMjnWEAGUGEqQq9R9CO3tnVHwCvgHhk2CcM8AMUUkRxxU1qud
 mCveQDTHv98hJ42/sfbg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 January 2012, Randy Dunlap wrote:
> > @@ -275,8 +275,8 @@ versions.
> >  If no 2.6.x.y kernel is available, then the highest numbered 2.6.x
> >  kernel is the current stable kernel.
> >  
> > -2.6.x.y are maintained by the "stable" team <stable@kernel.org>, and are
> > -released as needs dictate.  The normal release period is approximately 
> > +2.6.x.y are maintained by the "stable" team <stable@vger.kernel.org>, and
> > +are released as needs dictate.  The normal release period is approximately
> >  two weeks, but it can be longer if there are no pressing problems.  A
> >  security-related problem, instead, can cause a release to happen almost
> >  instantly.

Shouldn't the text get reworded as well to include the 3.x.y stable releases
and rename the 2.6.x.y releases to "longterm" instead of "stable"?

	Arnd

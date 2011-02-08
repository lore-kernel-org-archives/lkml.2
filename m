Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1BHKB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:01:58 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:51644 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1BHKB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mBMHJHVvRXoRCZsKP7Gf0c8Gmoofhm78R6uRav590WEZcWXS5f5LKt1ZizZy7c+d2y
         NLXJ/D7fM7+lYLSOVgTCB4f7J4Svqclj26K65/MZ2u3tClHAxeKppIhz7gv1OVNaElVA
         EK1gtoNV60/NAGGL75shnJ0AHF3w7KCxV5/Lk=
Date: Tue, 8 Feb 2011 18:01:54 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com, rdunlap@xenotime.net,
        xiyou.wangcong@gmail.com, w.sang@pengutronix.de
Subject: Re: Fwd: Fwd: [PATCH]Maintain =?utf-8?Q?Ch?=
	=?utf-8?Q?inese_Documentations=E2=99=AB?=
Message-ID: <20110208100153.GA2815@gmail.com>
References: <AANLkTimacOStZv-hrxo6iOWUDNem+h1cmaKCZQzw=0jr@mail.gmail.com>
 <20110208031638.GA4828@gmail.com>
 <20110207192249.5a478469.rdunlap@xenotime.net>
 <AANLkTimFFT-B_aPyfFJmMpvt9jhd98ckBah2vbK+WQJf@mail.gmail.com>
 <20110208033818.GA4922@gmail.com>
 <iiqti3$3b5$2@dough.gmane.org>
 <AANLkTinGn5oN01+33VgnnWHAqEZNxkoJeTgkjAjpC8LZ@mail.gmail.com>
 <20110208093020.GA2016@gmail.com>
 <20110208093528.GA2580@pengutronix.de>
 <AANLkTi=RgPS_tzBP+0=wxuh58cV=3_m+5=gYwG8ffkY0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=RgPS_tzBP+0=wxuh58cV=3_m+5=gYwG8ffkY0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Forwarded message ----------
> From: Wolfram Sang <w.sang@pengutronix.de>
> Date: 2011/2/8
> Subject: Re: Fwd: [PATCH]Maintain Chinese Documentations
> To: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com
> 
> 
> > > > +L:   xiyoulinuxkernelgroup@googlegroups.com
> > >
> > > NAK.
> > >
> > > Clearly linux-kernel@zh-kernel.org is more "official".
> 
> > Hi Brother Wang, I have mailed to linux-kernel@zh-kernel.org for some
> > translation problems but there is no response. So ... In fact, any
> > mailing list is ok if they are absolutely interested in kernel. We
> > will also send our translations for kernel-docs to
> > linux-kernel@zh-kernel.org. After talking with them we will patch for
> > kernel :)
> 
> If it helps the case, you could also have two "L:" entries?
A good idea :)
Updated patcher like following.

Thanks.
Best Regards.
Harry Wei.


Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Wang Cong <xiyou.wangcong@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dc0279e..afb6f7c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1692,6 +1692,12 @@ M:       Andy Whitcroft <apw@canonical.com>
 S:     Supported
 F:     scripts/checkpatch.pl

+CHINESE DOCUMENTATION
+M:     Harry Wei <harryxiyou@gmail.com>
+L:     xiyoulinuxkernelgroup@googlegroups.com
+L:	linux-kernel@zh-kernel.org(moderated for non-subscribers)
+S:     Maintained
+F:     Documentation/zh_CN/
+
 CISCO VIC ETHERNET NIC DRIVER
 M:     Vasanthy Kolluri <vkolluri@cisco.com>
 M:     Roopa Prabhu <roprabhu@cisco.com>
--
1.7.0.4


> 
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
> 
> iEYEARECAAYFAk1RDmAACgkQD27XaX1/VRt4UACgmAEnPGGDTzAivTBUI0+ce+8A
> kv8An3QIH0SbS8LxZ2kkjna6anoHlRpZ
> =TCxh
> -----END PGP SIGNATURE-----
> 
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!



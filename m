Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1BHKdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:33:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42935 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1BHKdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:33:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KxBAgaJsf2Eeev7Xg9h8mi/FvPDWrVMfI3EFs6IAi2/szdVug01K4WFzYrB9AuSvIS
         Aa3VPl+HwuaOSDs1Uw3Fl31ZzXsOG7V25/2B26ue5OHvFe9bBmRA1LoqGstG8jjpE1k9
         7yHpY1L5edW1t0YS/3C5JToURlNJgLoNEMJSc=
Date: Tue, 8 Feb 2011 18:33:33 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com, rdunlap@xenotime,
        xiyou.wangcong@gmail.com, w.sang@pengutronix.de
Subject: [PATCH]Maintain Chinese Documentations
Message-ID: <20110208103332.GA2932@gmail.com>
References: <AANLkTimFFT-B_aPyfFJmMpvt9jhd98ckBah2vbK+WQJf@mail.gmail.com>
 <20110208033818.GA4922@gmail.com>
 <iiqti3$3b5$2@dough.gmane.org>
 <AANLkTinGn5oN01+33VgnnWHAqEZNxkoJeTgkjAjpC8LZ@mail.gmail.com>
 <20110208093020.GA2016@gmail.com>
 <20110208093528.GA2580@pengutronix.de>
 <AANLkTi=RgPS_tzBP+0=wxuh58cV=3_m+5=gYwG8ffkY0@mail.gmail.com>
 <20110208100153.GA2815@gmail.com>
 <20110208101328.GB2580@pengutronix.de>
 <AANLkTimSgeRKsAckU+2iE9oqo33uanLeLaKTQdYkpfw=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimSgeRKsAckU+2iE9oqo33uanLeLaKTQdYkpfw=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 06:25:21PM +0800, harryxiyou wrote:
> ---------- Forwarded message ----------
> From: Wolfram Sang <w.sang@pengutronix.de>
> Date: 2011/2/8
> Subject: Re: Fwd: Fwd: [PATCH]Maintain Chinese Documentations♫
> To: Harry Wei <jiaweiwei.xiyou@gmail.com>
> Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
> davem@davemloft.net, greg@kroah.com, rdunlap@xenotime.net,
> xiyou.wangcong@gmail.com
> 
> 
> > +CHINESE DOCUMENTATION
> > +M:     Harry Wei <harryxiyou@gmail.com>
> > +L:     xiyoulinuxkernelgroup@googlegroups.com
> > +L:   linux-kernel@zh-kernel.org(moderated for non-subscribers)
> > +S:     Maintained
> > +F:     Documentation/zh_CN/
> 
> Space missing after .org
> 
> Some lines use spaces, one uses tabs. Please change that so it is
> consistent with the rest of the file.
Ok, updated like following :)

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
+M:	Harry Wei <harryxiyou@gmail.com>
+L:	xiyoulinuxkernelgroup@googlegroups.com
+L:	linux-kernel@zh-kernel.org (moderated for non-subscribers)
+S:	Maintained
+F:	Documentation/zh_CN/
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
> iEYEARECAAYFAk1RF0gACgkQD27XaX1/VRuFJACcCT6xukjRk9qPFXiIO/Zl1CwX
> Jo8AoJwFg6JbKyortM5bK7tuKFl4i75T
> =k2h8
> -----END PGP SIGNATURE-----
> 
> 
> 
> 
> -- 
> Best Regards.
> Harry Wei.
> Do what u like!



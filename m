Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab1AYGz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:55:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25039 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1AYGz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:55:57 -0500
Date: Tue, 25 Jan 2011 15:55:32 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/3] MAINTAINERS: Move s3c2410 drivers to ARM/SAMSUNG ARM
In-reply-to: <038101cbb5e1$021300e0$063902a0$%kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Cc: linux@simtec.co.uk, akpm@linux-foundation.org
Message-id: <01dc01cbbc5c$ded2c840$9c7858c0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=US-ASCII
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acuzz6SFkp+eUEFdSGCMnOAViLw4BACET6BgAZpR5eA=
References: <0bd9310fc4d79ee83f9f657640be251d84dbf86f.1294998254.git.ben-linux@fluff.org>
 <038101cbb5e1$021300e0$063902a0$%kim@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Ben Dooks wrote:
> >
> > There are currnetly two entries under the "SIMTEC EB2410ITX (BAST)"
> > machine entry for drivers/*/*s3c2410*, which is catching everything
> > s3c2410 driver related.
> >
> > This entry is for a specific S3C2410 based machine, so move these two
> > file entries to the "ARM/SAMSUNG ARM ARCHITECTURES" entry, where it
> > will reach a wider audience of interested parties.
> >
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > Cc: Simtec Linux Team <linux@simtec.co.uk>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> 

Hello Andrew,

Could you please pick this up in your tree?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> > ---
> >  MAINTAINERS |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 64d7621..464f0ec 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -975,6 +975,8 @@ S:	Maintained
> >  F:	arch/arm/plat-samsung/
> >  F:	arch/arm/plat-s3c24xx/
> >  F:	arch/arm/plat-s5p/
> > +F:	drivers/*/*s3c2410*
> > +F:	drivers/*/*/*s3c2410*
> >
> >  ARM/S3C2410 ARM ARCHITECTURE
> >  M:	Ben Dooks <ben-linux@fluff.org>
> > @@ -5565,8 +5567,6 @@ M:	Vincent Sanders <support@simtec.co.uk>
> >  W:	http://www.simtec.co.uk/products/EB2410ITX/
> >  S:	Supported
> >  F:	arch/arm/mach-s3c2410/
> > -F:	drivers/*/*s3c2410*
> > -F:	drivers/*/*/*s3c2410*
> >
> >  TI DAVINCI MACHINE SUPPORT
> >  M:	Kevin Hilman <khilman@deeprootsystems.com>
> > --
> > 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


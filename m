Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab1GGNmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:42:05 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:43986 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755650Ab1GGNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:42:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: ormH3vkVM1l24FSTFDM2GTahDJ9jaEcprdWuanEvGp7sbFY
 G7c9hgQacKWyufCB2DoAjsFYXKlFyayRQH.AkFLQuG2Y2fjxvelo23BWMVmX
 mL7nwSQDg.SdscfmZiCO.WRpImqpWYw0Zp2nb19aF4hf083X6IVHbZyCGBVN
 3lhMTcV3Cm8KnvFD4P0EmgG5SxKZULhXlnp6fXWMvI6wDfhVRcs_je3EYuql
 pw7ZIutzEYX5DyIXL3nLO010eB7VkLViSsxW674rLWaMoVfR7bVOnxmlAqlc
 jXadpoiJIzLNeHEFFJSjfwzw359H1._C7wrbqDfbp9q7smntUqWcCfuqX7ab
 HxRD.jyXUml_UjCAGgwxFI5L.
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 7 Jul 2011 08:42:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Piotr Hosowicz <piotr@hosowicz.com>
cc: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build issue with linux next. duplicate member _count in
 mm_types.h
In-Reply-To: <4E15AF1C.7080103@example.com>
Message-ID: <alpine.DEB.2.00.1107070841500.17376@router.home>
References: <4E143120.2020501@cam.ac.uk> <alpine.DEB.2.00.1107060933460.17202@router.home> <4E15AF1C.7080103@example.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Piotr Hosowicz wrote:

> On 06.07.2011 16:46, Christoph Lameter wrote:
> > On Wed, 6 Jul 2011, Jonathan Cameron wrote:
> >
> > > Getting:
> > >
> > >    CHK     include/linux/version.h
> > >    CHK     include/generated/utsrelease.h
> > > make[1]: `include/generated/mach-types.h' is up to date.
> > >    CC      arch/arm/kernel/asm-offsets.s
> > > In file included from include/linux/sched.h:64:0,
> > >                   from arch/arm/kernel/asm-offsets.c:13:
> > > include/linux/mm_types.h:74:15: error: duplicate member '_count'
> > > make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
> > > make: *** [prepare0] Error 2
>
> I have the same error on x86_64. I'll try again withj your patch.

Could you post a config file?


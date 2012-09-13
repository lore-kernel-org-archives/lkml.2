Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2IMKgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:36:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab2IMKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:36:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v9 10/13] ARM: SoC: convert imx6q to SoC descriptor
Date: Thu, 13 Sep 2012 08:44:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1347461906-13527-1-git-send-email-arnd@arndb.de> <1347461906-13527-11-git-send-email-arnd@arndb.de> <20120913011742.GB2725@S2101-09.ap.freescale.net>
In-Reply-To: <20120913011742.GB2725@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209130844.18667.arnd@arndb.de>
X-Provags-ID: V02:K0:b8XqDCjb1zVwqV6J+hm+Qu0IBn/doyqnbu/qPJmLJ+n
 b8igC+UErCa9YJp9+h8JgrWYmVetPdcaYL6hG1FGXm+va9b0ZA
 zEjEx8QYMxPt5bE41nq12HCft4uDtaH1paGkBirA2TdOeeUICC
 eV62X+av+YFJJ5t/XcFu/QWPHlynb+mYBLSQGiehZk/rgrhSTh
 HxSz7RbKGKYZg92buXNmgd9oXyVGlrEraTTawqHEj57fSU35Px
 tbC/EBfXPG0imCON0fjz1wt33l9AryszSANsuJiDw7+Gd/mSo8
 /XWAOfBM4HNmZSt9xNVpYjfYLcaVKGedaqcTtLrvyxoph2sucP
 2w5H6K7qab7bIvNlF60c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2012, Shawn Guo wrote:
> >  
> >  DT_MACHINE_START(IMX6Q, "Freescale i.MX6 Quad (Device Tree)")
> > +     .smp            = smp_ops(imx6q_soc_desc),
> 
> s/imx6q_soc_desc/imx_smp_ops

Yes, just noticed this myself when testing the series together with other patches.

> Otherwise,
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Thanks,

	Arnd


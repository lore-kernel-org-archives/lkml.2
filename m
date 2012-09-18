Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab2IRIfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 04:35:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab2IRIfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 04:35:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 02/24] ARM: at91: use __iomem pointers for MMIO
Date: Tue, 18 Sep 2012 08:05:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-3-git-send-email-arnd@arndb.de> <5056D794.5000107@atmel.com>
In-Reply-To: <5056D794.5000107@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209180805.55175.arnd@arndb.de>
X-Provags-ID: V02:K0:sJGSRwT5kI6klx2jZyIvhaX9LoRLGn+z2khr8Nxp4q6
 oOlVQFUQZIhzOj5JucRManz8ZuJPducvtsEjVSKEwwPe9JrIxU
 ppNWzzEbvNMfhaKOKbSAE5KjRlDNRW40OWtub3bsJXy4dmI2Zv
 WPdP4wmbjGPAjuwP+LfKpnozk5vkOGC9+d93S0ChuUVJcmgr2F
 /HgxYMmnhA+w/8R+C6CGmf4JcsZAT8eksvlRRTe6l6xQP8QlsH
 EQgBQ69ya7nEgH987+ZQLvzi1gK+2SLFNkbwu92I0HZLdMBjhA
 Kxra/+GxKK403VU80xui/clWLwAbM56NUlmmEZVUekkmGuS7+y
 udatiFnK9WDUQm4ZBHm0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 September 2012, Nicolas Ferre wrote:
> > @@ -94,7 +94,7 @@ static const u32 uarts_sam9x5[] = {
> >       0,
> >  };
> >  
> > -static inline const u32* decomp_soc_detect(u32 dbgu_base)
> > +static inline const u32* decomp_soc_detect(void __iomem*dbgu_base)
> 
> A whitespace is missing before the *, no?
> 

Fixed now, thanks!

	Arnd


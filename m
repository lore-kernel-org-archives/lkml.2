Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1K1Kdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 05:33:49 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:35114 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab1K1Kds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 05:33:48 -0500
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use
 =?UTF-8?Q?module=5Fplatform=5Fdriver=28=29?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 28 Nov 2011 11:33:42 +0100
From: Marc Zyngier <maz@misterjones.org>
Cc: <linux-kernel@vger.kernel.org>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Ralf Baechle <ralf@linux-mips.org>, Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        <linux-pcmcia@lists.infradead.org>
Organization: Metropolis
In-Reply-To: <1322369586.2522.3.camel@phoenix>
References: <1322369586.2522.3.camel@phoenix>
Message-ID: <d6963f1ecb253ca948d8106b10832fe1@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: axel.lin@gmail.com, linux-kernel@vger.kernel.org, hennerich@blackfin.uclinux.org, manuel.lauss@gmail.com, olof@lixom.net, ralf@linux-mips.org, eric.y.miao@gmail.com, linux@dominikbrodowski.net, linux-pcmcia@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 27 Nov 2011 12:53:06 +0800, Axel Lin <axel.lin@gmail.com> wrote:
> This patch converts the drivers in drivers/pcmcia/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
> Cc: Manuel Lauss <manuel.lauss@gmail.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Marc Zyngier <maz@misterjones.org>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pcmcia/bfin_cf_pcmcia.c |   13 +------------
>  drivers/pcmcia/db1xxx_ss.c      |   13 +------------
>  drivers/pcmcia/electra_cf.c     |   12 +-----------
>  drivers/pcmcia/m8xx_pcmcia.c    |   13 +------------
>  drivers/pcmcia/pxa2xx_viper.c   |   13 +------------
>  drivers/pcmcia/xxs1500_ss.c     |   13 +------------
>  6 files changed, 6 insertions(+), 71 deletions(-)
> 

For the viper part:
Acked-by: Marc Zyngier <maz@misterjones.org>
-- 
Who you jivin' with that Cosmik Debris?

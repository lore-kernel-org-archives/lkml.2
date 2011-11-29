Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1K2G3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 01:29:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52403 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab1K2G3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 01:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <1322369586.2522.3.camel@phoenix>
References: <1322369586.2522.3.camel@phoenix>
From: Manuel Lauss <manuel.lauss@googlemail.com>
Date: Tue, 29 Nov 2011 07:29:06 +0100
Message-ID: <CAOLZvyGnp5Uc0kOnHiLqn66=p100LkMaHnAYQR_mPwxbD465rQ@mail.gmail.com>
Subject: Re: [PATCH] pcmcia: convert drivers/pcmcia/* to use module_platform_driver()
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Manuel Lauss <manuel.lauss@gmail.com>, Olof Johansson <olof@lixom.net>,
        Marc Zyngier <maz@misterjones.org>, Ralf Baechle <ralf@linux-mips.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 5:53 AM, Axel Lin <axel.lin@gmail.com> wrote:
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
>  drivers/pcmcia/bfin_cf_pcmcia.c |   13 +------------
>  drivers/pcmcia/db1xxx_ss.c      |   13 +------------
>  drivers/pcmcia/electra_cf.c     |   12 +-----------
>  drivers/pcmcia/m8xx_pcmcia.c    |   13 +------------
>  drivers/pcmcia/pxa2xx_viper.c   |   13 +------------
>  drivers/pcmcia/xxs1500_ss.c     |   13 +------------
>  6 files changed, 6 insertions(+), 71 deletions(-)

For the db1xxx_ss.c part:
Acked-by: Manuel Lauss <manuel.lauss@googlemail.com>

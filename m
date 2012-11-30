Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990Ab2K3R6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:58:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61607 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2K3R6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:58:09 -0500
Date: Fri, 30 Nov 2012 09:58:08 -0800
From: Olof Johansson <olof@lixom.net>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Josh Cartwright <josh.cartwright@ni.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: add missing include for mdelay()
Message-ID: <20121130175808.GA4505@quad.lixom.net>
References: <20121130013730.GA30592@beefymiracle.amer.corp.natinst.com>
 <50B86BCA.7050103@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50B86BCA.7050103@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 09:18:18AM +0100, Maxime Ripard wrote:
> Le 30/11/2012 02:37, Josh Cartwright a écrit :
> >   CC      arch/arm/mach-sunxi/sunxi.o
> > ./arch/arm/mach-sunxi/sunxi.c: In function 'sunxi_restart':
> > ./arch/arm/mach-sunxi/sunxi.c:55:3: error: implicit declaration of function 'mdelay' [-Werror=implicit-function-declaration]
> > 
> > Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> 
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 

Thanks, applied on top of sunxi/soc2.


-Olof

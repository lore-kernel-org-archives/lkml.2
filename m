Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab2C1V5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:57:54 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:51522 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab2C1V5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:57:52 -0400
X-Greylist: delayed 2659 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Mar 2012 17:57:52 EDT
Date: Wed, 28 Mar 2012 22:13:28 +0100
From: Alexander Clouter <alex@digriz.org.uk>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        rmallon@gmail.com, kaloz@openwrt.org, khc@pm.waw.pl, tony@atomide.com,
        nico@fluxnic.net, eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        marek.vasut@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/5] arm: Use the plat_nand default partition parser
Message-ID: <20120328211327.GC6586@marmot>
References: <201203281113.10684.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203281113.10684.hartleys@visionengravers.com>
Organization: diGriz
X-URL: http://www.digriz.org.uk/
X-JabberID: alex@digriz.org.uk
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H Hartley Sweeten <hartleys@visionengravers.com> [2012-03-28 11:13:09-0700]:
>
> Use the default partition parser, cmdlinepart, provided by the plat_nand driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Imre Kaloz <kaloz@openwrt.org>
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Alexander Clouter <alex@digriz.org.uk>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> 
Acked-by: Alexander Clouter <alex@digriz.org.uk>

Thanks

-- 
Alexander Clouter
.sigmonster says: The only rose without thorns is friendship.

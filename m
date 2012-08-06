Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2HFRVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:21:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45270 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2HFRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:21:15 -0400
Date: Mon, 6 Aug 2012 18:21:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, arnd@arndb.de, dmitry.torokhov@gmail.com,
        STEricsson_nomadik_linux@list.st.com, sameo@linux.intel.com
Subject: Re: [PATCH 4/6] mfd: Use interrupt-parent as IRQ controller if
 specified in DT
Message-ID: <20120806172109.GA31409@gmail.com>
References: <1344250002-6011-1-git-send-email-lee.jones@linaro.org>
 <1344250002-6011-5-git-send-email-lee.jones@linaro.org>
 <20120806155446.GD29272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120806155446.GD29272@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 04:54:46PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 11:46:40AM +0100, Lee Jones wrote:
> 
> > -				domain = irq_find_host(parent->of_node);
> > +#ifdef CONFIG_OF
> > +				parent_node = of_irq_find_parent(np);
> > +#endif
> 
> Shouldn't of_irq_find_parent() be stubbed out by the header?  Every
> single user of this is going to need it.  Indeed, shouldn't we be making
> irq_find_host() just do this?

Sounds reasonable. I'll look into it tomorrow.
-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2HFRYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:24:15 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab2HFRYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:24:13 -0400
Date: Mon, 6 Aug 2012 18:24:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120806172406.GC31409@gmail.com>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
 <20120806081915.GA4518@core.coreip.homeip.net>
 <20120806153750.GI10524@gmail.com>
 <20120806160226.GF29272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120806160226.GF29272@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 05:02:26PM +0100, Mark Brown wrote:
> On Mon, Aug 06, 2012 at 04:37:52PM +0100, Lee Jones wrote:
> > On Mon, Aug 06, 2012 at 01:19:15AM -0700, Dmitry Torokhov wrote:
> 
> > > > +	ponkey->irq_dbf = (np) ? ab8500_irq_get_virq(ab8500, irq_dbf) : irq_dbf;
> > > > +	ponkey->irq_dbr = (np) ? ab8500_irq_get_virq(ab8500, irq_dbr) : irq_dbr;
> 
> > > Why this isn't done inside ab8500_irq_get_virq()?
> 
> > There's no reason why it can't be.
> 
> > My first version of the patch did just that in fact.
> 
> > Would that be your preference?
> 
> Restating my comment elsewhere...  why do we even need to do this in
> _get_virq() - I'd *really* expect this to be handled by the irq domain
> code.

I really should stop reading my emails backwards. :)

I'll look into this tomorrow.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

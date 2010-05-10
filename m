Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab0EJNaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 09:30:16 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:56278 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0EJNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 09:30:12 -0400
Date: Mon, 10 May 2010 15:29:48 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Matt Reimer <mreimer@vpop.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] pda_power: add support for writeable properties
Message-ID: <20100510132948.GN30801@buzzloop.caiaq.de>
References: <1273254733-7010-1-git-send-email-daniel@caiaq.de>
 <20100510094854.GB31804@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510094854.GB31804@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 10:48:54AM +0100, Mark Brown wrote:
> On Fri, May 07, 2010 at 07:52:11PM +0200, Daniel Mack wrote:
> 
> > +	/* TODO: support other types than int */
> > +	ret = strict_strtol(buf, 10, &long_val);
> > +	if (ret < 0)
> > +		return ret;
> 
> It'd be nicer if we could error out if this is used on properties with
> an inappropriate type but we don't seem to have type information
> anywhere convenient for implementing that, which is a bit unfortunate.

Yep, hence the 'TODO' :)
So currently the verdict is: if we can't convert the input to an
integer, we bail.

> Otherwise this looks reasonable in itself.

Ok, thanks.

Daniel


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1JXKO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:14:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:21838 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab1JXKO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,397,1315206000"; 
   d="scan'208";a="29511603"
Date: Mon, 24 Oct 2011 13:14:30 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 16/19] power_supply: Convert all users to new usb_phy
Message-ID: <20111024101430.GB2618@xps8300>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1317036092-3000-17-git-send-email-heikki.krogerus@linux.intel.com>
 <20111003131055.GC2487@xps8300>
 <20111010190812.GA12821@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111010190812.GA12821@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Oct 10, 2011 at 11:08:12PM +0400, Anton Vorontsov wrote:
> On Mon, Oct 03, 2011 at 04:10:55PM +0300, Heikki Krogerus wrote:
> [...]
> > > +static inline int
> > > +isp1704_read(struct isp1704_charger *isp, u32 reg)
> 
> Cosmetic nitpick: I don't see any reason to break this into two lines.
> 
> > > +{
> > > +	return usb_phy_io_read(isp->xceiv, reg);
> > > +}
> > > +
> > > +static inline int
> > > +isp1704_write(struct isp1704_charger *isp, u32 val, u32 reg)
> 
> Same here.
> 
> I assume you want this patch to go via some other tree, so feel
> free to add
> 
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> 
> Thanks!

Thanks Anton. I'll change them.

-- 
heikki

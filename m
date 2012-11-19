Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab2KSCRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 21:17:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:52741 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2KSCRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 21:17:32 -0500
Date: Sun, 18 Nov 2012 18:18:30 -0800
From: GregKH <greg@kroah.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Fabio Estevam <fabio.estevam@freescale.com>, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] w1: mxc_w1: Adapt the clock name to the new clock
 framework
Message-ID: <20121119021830.GA29111@kroah.com>
References: <1346950139-17059-1-git-send-email-fabio.estevam@freescale.com>
 <5069D830.6070307@freescale.com>
 <20121002053223.GA20786@ioremap.net>
 <CAOMZO5Aun8OMKY0wPm9TZfyqWwCNGa7xvWyR7W-bzwG_=1iecQ@mail.gmail.com>
 <20121003072815.GA1590@ioremap.net>
 <CAOMZO5C_uPVwNNhu+eUQCK9+J3xV5BNChf2nsjdNgEWRrQd4fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5C_uPVwNNhu+eUQCK9+J3xV5BNChf2nsjdNgEWRrQd4fA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 11:56:13PM -0200, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Wed, Oct 3, 2012 at 4:28 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> > On Tue, Oct 02, 2012 at 10:04:19PM -0300, Fabio Estevam (festevam@gmail.com) wrote:
> >> > I have no objections per se, but I'm hardly an expert in imx clock
> >> > framework :)
> >> >
> >> > Since it is only one patch in set of 3, I suppose it will be pushed
> >> > through different tree than w1. Feel free to add my ack.
> >> >
> >> > Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> >>
> >> Could this series go via your tree?
> >
> > Please send it to Greg (added to CC), but I would like someone who knows
> > this platform (and not only w1 bits, which look good) to acknowledge changes,
> > feel free to add mine.
> 
> Could you please ack this series?
> 
> Greg,
> 
> Should I re-send the patches with  Evgeniy and Sascha's acks?

Please do so, so that I can apply them to my tree.

thanks,

greg k-h

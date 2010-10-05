Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0JETLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:11:16 -0400
Received: from kroah.org ([198.145.64.141]:38992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0JETLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:11:14 -0400
Date: Tue, 5 Oct 2010 12:04:21 -0700
From: Greg KH <greg@kroah.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 1/2] omap: add dsp platform device
Message-ID: <20101005190421.GB20825@kroah.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
 <1286208555-8829-2-git-send-email-felipe.contreras@gmail.com>
 <20101005155656.GA27130@kroah.com>
 <20101005162830.GI3117@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005162830.GI3117@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:28:30AM -0700, Tony Lindgren wrote:
> * Greg KH <greg@kroah.com> [101005 09:01]:
> > On Mon, Oct 04, 2010 at 07:09:14PM +0300, Felipe Contreras wrote:
> > > Otherwise tidspbridge cannot work.
> > > 
> > > It looks like this was dropped in the conversion to staging. I took the
> > > liberty of doing some cleaning up.
> > > 
> > > Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> > > ---
> > >  arch/arm/mach-omap2/Makefile          |    4 ++
> > >  arch/arm/mach-omap2/dsp.c             |   85 +++++++++++++++++++++++++++++++++
> > >  arch/arm/plat-omap/common.c           |    2 +
> > >  arch/arm/plat-omap/devices.c          |   30 ++++++++++++
> > >  arch/arm/plat-omap/include/plat/dsp.h |   31 ++++++++++++
> > 
> > I need an ack from some omap maintainers before I can take this into the
> > staging tree.
> 
> Looks good to me
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks, I'll go queue it up now.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab0JEQ2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:28:35 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:57501 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0JEQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:28:34 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NOAZ7qQw1ACDfOziWl77A
Date: Tue, 5 Oct 2010 09:28:30 -0700
From: Tony Lindgren <tony@atomide.com>
To: Greg KH <greg@kroah.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Hiroshi Doyu <hiroshi.doyu@nokia.com>
Subject: Re: [PATCH 1/2] omap: add dsp platform device
Message-ID: <20101005162830.GI3117@atomide.com>
References: <1286208555-8829-1-git-send-email-felipe.contreras@gmail.com>
 <1286208555-8829-2-git-send-email-felipe.contreras@gmail.com>
 <20101005155656.GA27130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005155656.GA27130@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <greg@kroah.com> [101005 09:01]:
> On Mon, Oct 04, 2010 at 07:09:14PM +0300, Felipe Contreras wrote:
> > Otherwise tidspbridge cannot work.
> > 
> > It looks like this was dropped in the conversion to staging. I took the
> > liberty of doing some cleaning up.
> > 
> > Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> > ---
> >  arch/arm/mach-omap2/Makefile          |    4 ++
> >  arch/arm/mach-omap2/dsp.c             |   85 +++++++++++++++++++++++++++++++++
> >  arch/arm/plat-omap/common.c           |    2 +
> >  arch/arm/plat-omap/devices.c          |   30 ++++++++++++
> >  arch/arm/plat-omap/include/plat/dsp.h |   31 ++++++++++++
> 
> I need an ack from some omap maintainers before I can take this into the
> staging tree.

Looks good to me

Acked-by: Tony Lindgren <tony@atomide.com>

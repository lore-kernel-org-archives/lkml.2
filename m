Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865Ab1CaGqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:46:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:45506 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1CaGqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:46:14 -0400
Date: Thu, 31 Mar 2011 08:46:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dma: ipu: Convert interupt code
In-Reply-To: <1301550382.18522.9.camel@vkoul-udesk3>
Message-ID: <alpine.LFD.2.00.1103310845400.22418@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103251220000.31464@localhost6.localdomain6> <1301550382.18522.9.camel@vkoul-udesk3>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Koul, Vinod wrote:

> On Fri, 2011-03-25 at 12:21 +0100, Thomas Gleixner wrote:
> > Convert to the new irq chip functions and cleanup the name space.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  drivers/dma/ipu/ipu_irq.c |   58 +++++++++++++++++++++++-----------------------
> >  1 file changed, 29 insertions(+), 29 deletions(-)
> This looks fine, I will apply it once I merged .39-rc1 to my tree

That patch will reverse apply then. :)


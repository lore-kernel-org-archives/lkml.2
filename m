Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab2ADTGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:06:33 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38380 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756810Ab2ADTG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:26 -0500
Date: Wed, 4 Jan 2012 11:30:57 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] gpio/microblaze: Eliminate duplication of
 of_get_named_gpio_flags()
Message-ID: <20120104183057.GU15503@ponder.secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
 <1320801583-12774-2-git-send-email-grant.likely@secretlab.ca>
 <4EF1B36A.8050304@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF1B36A.8050304@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:22:34AM +0100, Michal Simek wrote:
> Grant Likely wrote:
> >of_reset_gpio_handle() is largely a cut-and-paste copy of
> >of_get_named_gpio_flags(). There really isn't any reason for the
> >split, so this patch deletes the duplicate function
> >
> >Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >Cc: Michal Simek <monstr@monstr.eu>
> >---
> > arch/microblaze/kernel/reset.c |   43 +--------------------------------------
> > 1 files changed, 2 insertions(+), 41 deletions(-)
> 
> Sorry for taking to long.
> 
> Tested and applied to microblaze tree.

I'd rather take this one through the gpio tree if that is okay.

g.

> 
> Thanks,
> Michal
> 
> -- 
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian

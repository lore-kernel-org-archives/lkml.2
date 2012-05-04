Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094Ab2EDADS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:03:18 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51699 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759073Ab2EDADO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:03:14 -0400
X-Sasl-enc: mzqr+b3VxqqaUAD85eKJLRyCx7hV/8F2m87gDk4mMcyR 1336089793
Date: Thu, 3 May 2012 17:03:12 -0700
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120504000312.GB32225@kroah.com>
References: <1335529449-28046-1-git-send-email-santosh.shilimkar@ti.com>
 <CAP=VYLrCTOb9Qtz_HU5976cew_FR=qN6=x=_nD48ZprTcCjoUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLrCTOb9Qtz_HU5976cew_FR=qN6=x=_nD48ZprTcCjoUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 06:38:23PM -0400, Paul Gortmaker wrote:
> On Fri, Apr 27, 2012 at 8:24 AM, Santosh Shilimkar
> <santosh.shilimkar@ti.com> wrote:
> > Add a driver for the EMIF SDRAM controller used in Texas Instrument SoCs
> 
> Hi Santosh,
> 
> Can you send Greg a patch that adds proper dependencies to the Kconfig?
> I was going to simply add an ARM dependency, but perhaps you want to
> restrict it further to a subset of OMAP platforms?
> 
> At the moment it is causing build failures in other architectures.
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/6243036/

I think there's a config option for readl/writel, but yes, ARM would
probably be fine as well.

thanks,

greg k-h

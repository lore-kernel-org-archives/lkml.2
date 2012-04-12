Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880Ab2DLOKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:10:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48285 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab2DLOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:10:53 -0400
X-Sasl-enc: msmSJaU9DbgI1aZ2aocryhPoqgVgCkoOLQQ8izzAFzWT 1334239852
Date: Thu, 12 Apr 2012 07:10:50 -0700
From: Greg KH <greg@kroah.com>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Paul Walmsley <paul@pwsan.com>, "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: Re: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
Message-ID: <20120412141050.GA31968@kroah.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com>
 <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com>
 <20120412030044.GA26236@kroah.com>
 <4F867A95.9030104@ti.com>
 <20120412131045.GB31384@kroah.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 01:34:15PM +0000, Mohammed, Afzal wrote:
> Hi Greg,
> 
> On Thu, Apr 12, 2012 at 18:40:45, Greg KH wrote:
> > On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
> > > I was hoping that we will have some thing like drivers/memory/*
> > > but since it doesn't exist, we used drivers/misc.
> > 
> > Why not create it?  I have no objection to that, it makes it more
> > obvious as to what this really is.
> 
> There is another memory controller used in a few TI SoCs,
> namely GPMC [1], do you prefer having it too there.

Sure, why not?

> As of now it is not a driver, platform code handles GPMC, a patch
> series for converting it into a driver (but still residing in
> platform folder) was sent a few days back [2,3].

People are moving things out of the platform folder, so drivers/memory
makes sense.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab1JLHEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:04:51 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47325 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab1JLHEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:04:49 -0400
Date: Wed, 12 Oct 2011 12:34:29 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: Greg KH <greg@kroah.com>, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
Message-ID: <20111012070429.GC2080@manju-desktop>
References: <20111008155502.GB616@kroah.com>
 <361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <361419345.198335.1318268242916.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:37:22AM -0700, Andrei Warkentin wrote:
> Hi,
> 
> ----- Original Message -----
> > From: "Greg KH" <greg@kroah.com>
> > To: "Josh Triplett" <josh@joshtriplett.org>
> > Cc: "G, Manjunath Kondaiah" <manjugk@ti.com>, linux-arm-kernel@lists.infradead.org, "Grant Likely"
> > <grant.likely@secretlab.ca>, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
> > "Dilan Lee" <dilee@nvidia.com>, "Mark Brown" <broonie@opensource.wolfsonmicro.com>, Manjunath@jasper.es
> > Sent: Saturday, October 8, 2011 11:55:02 AM
> > Subject: Re: [PATCH 2/5] drivercore: Add driver probe deferral mechanism
> > 
> 
> I'm a bit of a fly on the wall here, but I'm curious how this impacts suspend/resume.
> device_initialize->device_pm_init are called from device_register, so certainly this
> patch doesn't also ensure that the PM ordering matches probe ordering, which is bound
> to break suspend, right? Was this ever tested with the OMAP target? Shouldn't the
> PM change be also part of this patch set? I don't see why you would want to have this in
> without the PM changes.

suspend/resume handling is already in TODO list:
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/135461

-M

> 
> Maybe I have it all wrong though :-).
> 
> A

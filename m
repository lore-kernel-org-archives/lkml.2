Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1CKQgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:36:50 -0500
Received: from kroah.org ([198.145.64.141]:46810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab1CKQgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:36:48 -0500
Date: Fri, 11 Mar 2011 08:35:22 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311163522.GA9291@kroah.com>
References: <4D79F068.2080009@linaro.org>
 <201103111331.13932.arnd@arndb.de>
 <20110311152938.GB29920@sirena.org.uk>
 <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
 <20110311162759.GS1760@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311162759.GS1760@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 04:27:59PM +0000, Mark Brown wrote:
> On Fri, Mar 11, 2011 at 08:14:21AM -0800, Greg KH wrote:
> > On Fri, Mar 11, 2011 at 04:03:09PM +0000, Mark Brown wrote:
> 
> > > Like I say, it's not just MAC addresses that can need configuring this
> > > way - it can be other random "you're wired up this way" type
> > > information that would normally be figured out from the USB IDs.
> 
> > And all of that should be done in userspace, like all other device
> > names, I still fail to see what is so different here from any other type
> > of system.
> 
> I'm actually not that fussed about the MAC address use case itself and
> do tend to agree with you that that's handlable in userspace but for the
> other things that might need to be configured there's a lot of things
> that for non-discoverable buses we're currently passing through platform
> data so switching to bouncing things through userspace would itself be a
> substantial change from other systems.

But USB _is_ discoverable, that's my point.

> You can't in general rely on the system being neatly abstracted and
> while discoverable buses do avoid many problems in this sort of area
> there are still things which can only be discovered through reference to
> the schematics or similar, especially if you care about the microamps.

Again, that's not USB, so it isn't relevant here.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab1CKQ2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:28:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55603 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754482Ab1CKQ2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:28:02 -0500
Date: Fri, 11 Mar 2011 16:27:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Arnd Bergmann <arnd@arndb.de>, andy.green@linaro.org,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110311162759.GS1760@opensource.wolfsonmicro.com>
References: <4D79F068.2080009@linaro.org>
 <201103111331.13932.arnd@arndb.de>
 <20110311152938.GB29920@sirena.org.uk>
 <201103111654.04089.arnd@arndb.de>
 <20110311160308.GQ1760@opensource.wolfsonmicro.com>
 <20110311161421.GA7843@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311161421.GA7843@kroah.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 08:14:21AM -0800, Greg KH wrote:
> On Fri, Mar 11, 2011 at 04:03:09PM +0000, Mark Brown wrote:

> > Like I say, it's not just MAC addresses that can need configuring this
> > way - it can be other random "you're wired up this way" type
> > information that would normally be figured out from the USB IDs.

> And all of that should be done in userspace, like all other device
> names, I still fail to see what is so different here from any other type
> of system.

I'm actually not that fussed about the MAC address use case itself and
do tend to agree with you that that's handlable in userspace but for the
other things that might need to be configured there's a lot of things
that for non-discoverable buses we're currently passing through platform
data so switching to bouncing things through userspace would itself be a
substantial change from other systems.

You can't in general rely on the system being neatly abstracted and
while discoverable buses do avoid many problems in this sort of area
there are still things which can only be discovered through reference to
the schematics or similar, especially if you care about the microamps.

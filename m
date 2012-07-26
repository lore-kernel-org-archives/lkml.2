Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab2GZV21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:28:27 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab2GZV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:28:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Date: Thu, 26 Jul 2012 23:34:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>
References: <201207032302.17805.rjw@sisk.pl> <87vchb4ar8.fsf@ti.com> <20120726210952.GG4560@opensource.wolfsonmicro.com>
In-Reply-To: <20120726210952.GG4560@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207262334.11789.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 26, 2012, Mark Brown wrote:
> On Wed, Jul 25, 2012 at 05:38:35PM -0700, Kevin Hilman wrote:
> 
> > That being said, I'm not sure why ti,hwmods is being used as an example
> > for powerdomains.  hwmods describe the integration of SoC IP blocks
> > (base addr, IRQ, DMA channel etc., which are being moved to DT) as well
> > as a bunch of SoC specific PM register descriptions.  This stuff is
> > SoC-specific PM register layout, so being very SoC specific, it has the
> > 'ti' prefix in the DT binding.
> 
> I think the thing here is that one aspect of that SoC integration is
> which power domain the blocks are in.  Describing which power domain an
> IP is in isn't a million miles away from describing which hwmod applies
> to an IP.

I agree.

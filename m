Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab1IMMjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab1IMMjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:39:13 -0400
Subject: Re: [PATCH 06/24] C6X: devicetree
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Date: Tue, 13 Sep 2011 08:39:04 -0400
In-Reply-To: <6360771.ouEC5EKNMR@wuerfel>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <20110912201102.GF23345@ponder.secretlab.ca>
	 <1315869636.11280.26.camel@deneb.redhat.com> <6360771.ouEC5EKNMR@wuerfel>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315917546.11280.38.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 08:43 +0200, Arnd Bergmann wrote:
> On Monday 12 September 2011 19:20:35 Mark Salter wrote:
> > On Mon, 2011-09-12 at 14:11 -0600, Grant Likely wrote:
> > > On Wed, Aug 31, 2011 at 05:26:41PM -0400, Mark Salter wrote:
> > > > +           interrupt-controller;
> > > > +           #interrupt-cells = <1>;
> > > > +           compatible = "ti,c64x+core-pic";
> > > 
> > > The interrupt controller isn't addressable?  Is it integrated into
> > > the CPU?
> > 
> > Yes, that core controller is controlled through registers accessed
> > with special-purpose instructions, not MMIO. Other controllers, like
> > megamodule and some as-yet unimplemented use MMIO.
> 
> Are these instructions specific to the interrupt controller or
> do they access a register space that can contain arbitrary
> devices?
> 
> If there is a separate address space for special devices, it might
> be good to describe that in the device tree, like we do for PCI
> I/O space.
> 

It is a core register area. Similar to ARM or MIPS coprocessor
registers.

--Mark



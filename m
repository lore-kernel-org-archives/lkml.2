Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab2GaSjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:39:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:61401 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2GaSjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:39:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="179909683"
Date: Tue, 31 Jul 2012 11:39:12 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Denis Turischev <denis@compulab.co.il>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] xhci: EHCI/XHCI ports switching on Intense-PC.
Message-ID: <20120731183912.GE3276@xanatos>
References: <5004454E.9030903@compulab.co.il>
 <20120724194609.GA6681@xanatos>
 <20120730223406.GA9290@xanatos>
 <2062329.UHa94WQ5Fk@linux-lqwf.site>
 <20120731170634.GA3276@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120731170634.GA3276@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 10:06:34AM -0700, Sarah Sharp wrote:
> On Tue, Jul 31, 2012 at 06:49:50AM +0200, Oliver Neukum wrote:
> > On Monday 30 July 2012 15:34:06 Sarah Sharp wrote:
> > > Hi Denis,
> > > 
> > > Can you send me the output of `sudo dmidecode`?  I'd like to see if I
> > > can make a more general patch apply to the Intense-PC.
> > 
> > As this is for shutdown, why not all systems?
> 
> Because it will cause a BIOS delay on the next boot.  Approximately
> 100 ms.  Some people trying to do extremely fast boot will care about
> that delay.

However, looking at the Intense-PC SMBIOS info, it looks like I can't
make the patch more generic.  I'll have to key off of PCI ID, and all
PPT systems will have the ports switched back to EHCI.

Sarah Sharp

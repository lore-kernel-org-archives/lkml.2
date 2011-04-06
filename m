Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1DFSHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 14:07:15 -0400
Received: from mail.solarflare.com ([216.237.3.220]:7795 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab1DFSHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 14:07:13 -0400
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
In-Reply-To: <20110406175113.GC2757@sortiz-mobl>
References: <20110401104756.2f5c6f7a@debxo>
	 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
	 <20110401235239.GE29397@sortiz-mobl>
	 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
	 <20110404100314.GC2751@sortiz-mobl>
	 <20110405030428.GB29522@ponder.secretlab.ca>
	 <20110406152322.GA2757@sortiz-mobl> <20110406155805.GA20095@suse.de>
	 <20110406170537.GB2757@sortiz-mobl> <1302110209.2840.20.camel@bwh-desktop>
	 <20110406175113.GC2757@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 06 Apr 2011 19:07:08 +0100
Message-ID: <1302113228.2840.29.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Apr 2011 18:07:12.0819 (UTC) FILETIME=[743D4030:01CBF485]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18056.005
X-TM-AS-Result: No--20.709000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 19:51 +0200, Samuel Ortiz wrote:
> Hi Ben,
> 
> On Wed, Apr 06, 2011 at 06:16:49PM +0100, Ben Hutchings wrote:
> > > So, adding an MFD cell pointer to the device structure allows us to cleanly
> > > pass both pieces of information, while keeping all the MFD sub drivers
> > > independant from the MFD core if they want/can.
> > 
> > Why isn't an MFD the parent of its component devices?
> It actually is. How would that help here ?

I was thinking you could encode the component address in the
platform_device name (just as the bus address is the name of a normal
bus device).  That plus the parent device pointer would be sufficient
information to look up the mfd_cell.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


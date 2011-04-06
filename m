Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1DFRvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:51:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:45373 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1DFRvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,311,1299484800"; 
   d="scan'208";a="676038043"
Date: Wed, 6 Apr 2011 19:51:14 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Andres Salomon <dilinger@queued.net>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, khali@linux-fr.org,
        ben-linux@fluff.org, Peter Korsgaard <jacmet@sunsite.dk>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Mocean Laboratories <info@mocean-labs.com>
Subject: Re: [PATCH 07/19] timberdale: mfd_cell is now implicitly available
 to drivers
Message-ID: <20110406175113.GC2757@sortiz-mobl>
References: <20110401104756.2f5c6f7a@debxo>
 <BANLkTi=bCd_+f=EG-O=U5VH_ZNjFhxkziQ@mail.gmail.com>
 <20110401235239.GE29397@sortiz-mobl>
 <BANLkTi=bq=OGzXFp7qiBr7x_BnGOWf=DRQ@mail.gmail.com>
 <20110404100314.GC2751@sortiz-mobl>
 <20110405030428.GB29522@ponder.secretlab.ca>
 <20110406152322.GA2757@sortiz-mobl>
 <20110406155805.GA20095@suse.de>
 <20110406170537.GB2757@sortiz-mobl>
 <1302110209.2840.20.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302110209.2840.20.camel@bwh-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Apr 06, 2011 at 06:16:49PM +0100, Ben Hutchings wrote:
> > So, adding an MFD cell pointer to the device structure allows us to cleanly
> > pass both pieces of information, while keeping all the MFD sub drivers
> > independant from the MFD core if they want/can.
> 
> Why isn't an MFD the parent of its component devices?
It actually is. How would that help here ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

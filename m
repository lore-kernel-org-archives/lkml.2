Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1EVUiC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:38:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:55050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab1EVUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,253,1304319600"; 
   d="scan'208";a="6424298"
Date: Sun, 22 May 2011 22:37:51 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Margarita Olaya <magi@slimlogic.co.uk>
Subject: Re: [PATCHv4 0/4] Initial support for TPS65912 PMIC
Message-ID: <20110522203750.GG18610@sortiz-mobl>
References: <BANLkTi=5MY7Lr4KU4vtOFSQiOedKGXxZLw@mail.gmail.com>
 <BANLkTim56oPzQ_knGc6ezg+9_CY2kqshqQ@mail.gmail.com>
 <1305975198.3317.1.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305975198.3317.1.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Sat, May 21, 2011 at 11:53:17AM +0100, Liam Girdwood wrote:
> On Thu, 2011-05-19 at 13:51 -0500, Margarita Olaya wrote:
> > Hi,
> > 
> > On Mon, May 16, 2011 at 6:02 PM, Margarita Olaya <magi@slimlogic.co.uk> wrote:
> > > Hi,
> > >
> > > This is the initial version of the TPS65912 PMIC, a power management IC
> > > for multimedia products.
> > >
> > > The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> > > voltage to main processor and other components. The chip includes a
> > > GPIO module.
> > >
> > > Changes from V3:
> > > - split core driver into tps65912-spi and tps65912-i2c
> > > - create new function in regulator with common code in set/get mode
> > >
> > 
> > Do you have any comments on this version of the driver? Please let me know them.
> > 
> 
> Grant, Samuel,  If the mfd/gpio sections are fine with you I can take
> via regulator. I plan to do the regulator pull request on Monday or
> Tuesday.
I'm fine with it. Please add my:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

to patches #1 and #2 of this serie. Thanks for taking it.

Cheers,
Samuel.


> Thanks !
> 
> Liam
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1EWUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:22:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35465 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222Ab1EWUWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:22:39 -0400
X-ExtLoop1: 1
Date: Mon, 23 May 2011 22:22:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "grant@secretlab.ca" <grant@secretlab.ca>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
Message-ID: <20110523202238.GA12247@sortiz-mobl>
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
 <4DBAD7E8.8090703@ti.com>
 <20110429220651.GG7497@ponder.secretlab.ca>
 <20110513184153.GZ8970@sortiz-mobl>
 <20110515212044.GB30725@angua.secretlab.ca>
 <20110522204404.GJ18610@sortiz-mobl>
 <4DDA1647.9060502@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDA1647.9060502@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Mon, May 23, 2011 at 09:09:43AM +0100, Liam Girdwood wrote:
> On 22/05/11 21:44, Samuel Ortiz wrote:
> > Hi Grant,
> > 
> > On Sun, May 15, 2011 at 03:20:44PM -0600, Grant Likely wrote:
> >>> Would you be ok with moving this one to drivers/gpio/ ? And in general, moving
> >>> most of the GPIO drivers under drivers/mfd/ back to drivers/gpio/ ?
> >>> David didn't want to take the basic MFD related GPIO drivers, that's why we
> >>> have several of them under mfd.
> >>
> >> Yes, move them to GPIO.  That is where they belong.
> > Thanks, I'll prepare that for the next merge window.
> > 
> 
> Ah, I thought you acked the whole series here and applied it yesterday. I can remove this one if required.
>
No, please go ahead, and I'll queue whatever I'd like to see removed from
drivers/mfd/ for the next merge window.

Cheers,
Samuel.
 
> Thanks

> 
> Liam 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

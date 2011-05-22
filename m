Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1EVUoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 16:44:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:56651 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1EVUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 16:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,253,1304319600"; 
   d="scan'208";a="2676290"
Date: Sun, 22 May 2011 22:44:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Liam Girdwood <lrg@ti.com>, "grant@secretlab.ca" <grant@secretlab.ca>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCHv5 2/4] TPS65910: GPIO: Add GPIO driver
Message-ID: <20110522204404.GJ18610@sortiz-mobl>
References: <2CAE1D41-48DC-457F-8FF3-E45B17AC3E0F@slimlogic.co.uk>
 <4DBAD7E8.8090703@ti.com>
 <20110429220651.GG7497@ponder.secretlab.ca>
 <20110513184153.GZ8970@sortiz-mobl>
 <20110515212044.GB30725@angua.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515212044.GB30725@angua.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Sun, May 15, 2011 at 03:20:44PM -0600, Grant Likely wrote:
> > Would you be ok with moving this one to drivers/gpio/ ? And in general, moving
> > most of the GPIO drivers under drivers/mfd/ back to drivers/gpio/ ?
> > David didn't want to take the basic MFD related GPIO drivers, that's why we
> > have several of them under mfd.
> 
> Yes, move them to GPIO.  That is where they belong.
Thanks, I'll prepare that for the next merge window.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

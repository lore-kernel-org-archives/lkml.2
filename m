Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1DZOEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:04:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:58913 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab1DZOEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:04:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,268,1301900400"; 
   d="scan'208";a="425694343"
Date: Tue, 26 Apr 2011 16:04:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        linux-kernel@vger.kernel.org, lrg@ti.com,
        Graeme Gregory <gg@slimlogic.co.uk>, grant@secretlab.ca
Subject: Re: [PATCHv4 2/4] TPS65910: GPIO: Add GPIO driver
Message-ID: <20110426140447.GC3175@sortiz-mobl>
References: <8BC87CF8-EAB5-40A9-AAFB-D4F7521B3E04@slimlogic.co.uk>
 <20110421151130.GB25526@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110421151130.GB25526@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 04:11:30PM +0100, Mark Brown wrote:
> On Thu, Apr 21, 2011 at 09:35:47AM -0500, Jorge Eduardo Candelaria wrote:
> > From: Graeme Gregory <gg@slimlogic.co.uk>
> > 
> > TPS65910 has one configurable GPIO that can be used for several
> > purposes. Subsequent versions of the TPS chip support more than
> > one GPIO.
> > 
> > Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
> 
> CCing in Grant who's taken over the GPIO subsystem.
Thanks Mark.
David used to prefer to keep simple GPIO drivers like this one within the MFD
subsystem, although I had a preference for keeping all things GPIO related
under drivers/gpio/. Grant, what's your preference ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

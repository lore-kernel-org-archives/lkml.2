Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2ATKAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 05:00:42 -0500
Received: from imr3.ericy.com ([198.24.6.13]:36470 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab2ATKAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 05:00:41 -0500
Date: Fri, 20 Jan 2012 01:57:21 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        Corentin Labbe <corentin.labbe@geomatys.fr>,
        Dirk Eibach <eibach@gdsys.de>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Riku Voipio <riku.voipio@iki.fi>,
        Guillaume Ligneul <guillaume.ligneul@gmail.com>,
        David George <david.george@ska.ac.za>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
        Rudolf Marek <r.marek@assembler.cz>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] hwmon: convert drivers/hwmon/* to use
 module_i2c_driver()
Message-ID: <20120120095721.GA31838@ericsson.com>
References: <1327045098.29773.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1327045098.29773.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 02:38:18AM -0500, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_i2c_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Corentin Labbe <corentin.labbe@geomatys.fr>
> Cc: Dirk Eibach <eibach@gdsys.de>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: Steve Glendinning <steve.glendinning@smsc.com>
> Cc: Riku Voipio <riku.voipio@iki.fi>
> Cc: Guillaume Ligneul <guillaume.ligneul@gmail.com>
> Cc: David George <david.george@ska.ac.za>
> Cc: "Hans J. Koch" <hjk@hansjkoch.de>
> Cc: Marc Hulsman <m.hulsman@tudelft.nl>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> ---

Applied.

Thanks,
Guenter

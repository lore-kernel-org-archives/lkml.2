Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1KYRAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 12:00:19 -0500
Received: from imr4.ericy.com ([198.24.6.9]:54554 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab1KYRAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 12:00:15 -0500
Date: Fri, 25 Nov 2011 08:57:08 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corentin Labbe <corentin.labbe@geomatys.fr>,
        Dirk Eibach <eibach@gdsys.de>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Riku Voipio <riku.voipio@iki.fi>,
        Guillaume Ligneul <guillaume.ligneul@gmail.com>,
        David George <david.george@ska.ac.za>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
        Rudolf Marek <r.marek@assembler.cz>, Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: convert drivers/hwmon/* to use module_i2c_driver()
Message-ID: <20111125165708.GA11317@ericsson.com>
References: <1322204787.11718.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322204787.11718.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 02:06:27AM -0500, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_i2c_driver() macro which makes the code smaller and a bit
> simpler.
> 
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
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

What is the plan for those patches ? Are they expected to all go through the same tree,
or through individual trees after the necessary defines are introduced into mainline ?

Guenter

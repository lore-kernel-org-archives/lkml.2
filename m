Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab2B0NvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 08:51:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:14621 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2B0NvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 08:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121883432"
Date: Mon, 27 Feb 2012 14:58:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, kernel@pengutronix.de
Subject: Re: [PATCH 1/3] mfd: Add basic support for the Congatec CGEB BIOS
 interface
Message-ID: <20120227135827.GM27687@sortiz-mobl>
References: <1328102793-4313-1-git-send-email-s.hauer@pengutronix.de>
 <1328102793-4313-2-git-send-email-s.hauer@pengutronix.de>
 <20120220163927.GY5387@sortiz-mobl>
 <20120220180752.GV3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220180752.GV3852@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,


On Mon, Feb 20, 2012 at 07:07:52PM +0100, Sascha Hauer wrote:
> Hi Samuel,
> 
> On Mon, Feb 20, 2012 at 05:39:27PM +0100, Samuel Ortiz wrote:
> > Hi Sascha,
> > 
> > On Wed, Feb 01, 2012 at 02:26:31PM +0100, Sascha Hauer wrote:
> > > The Congatec CGEB is a BIOS interface found on some Congatec x86
> > > modules. It provides access to on board peripherals like I2C busses
> > > and watchdogs. This driver contains the basic support for accessing
> > > the CGEB interface and registers the child devices.
> > After looking at the code, I'm not entirely sure this one belongs to
> > drivers/mfd/. Have you thought about putting it under arch/x86/platform/ ?
> > There are similar examples there, like uv or olpc.
> 
> I don't mind putting it in arch/x86/platform instead. I'm an ARM guy and
> on ARM there currently is a rush to move everything looking remotely
> like a driver out of arch/arm/ to drivers/, so putting it under
> drivers/mfd/ seemed logical to me.
Yes, this seems to be the trend apparently. Could you try pushing that into
the x86/platform, please ? If they put you under fire, I guess I could take
this patchset. But they have several "BIOS interfaces" there already...

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

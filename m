Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2IDQJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:09:45 -0400
Received: from etezian.org ([198.101.225.253]:57921 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab2IDQJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:09:44 -0400
Date: Tue, 4 Sep 2012 18:09:38 +0200
From: Andi Shyti <andi@etezian.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] cbus/retu drivers to mainline
Message-ID: <20120904160938.GB4361@Jack.Whiskey>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaro,

On Mon, Sep 03, 2012 at 11:23:21PM +0300, Aaro Koskinen wrote:
> This patch set introduces drivers for CBUS access and Retu multifunction
> chip found on Nokia Internet Tablets (770, N800, N810). It would be
> nice get these patches applied as the functionality of these devices is
> severely lacking without Retu. E.g. watchdog support is mandatory at
> least on Nokia N800, you cannot currently run the mainline kernel for
> longer than ~60 seconds (there is no way to disable the watchdog).
> 
> Drivers originate from linux-omap cbus branch and have been cleaned
> up/rewritten around i2c and MFD core.
> 
> Patches have been tested on top of 3.6-rc4 with Nokia N800 (watchdog
> feeding works, power off shuts down the device, power button triggers
> IRQs and input events).
> 
> Changes since the RFC version
> (http://marc.info/?l=linux-omap&m=134618967116737&w=2):
> 	- added DT support for getting i2c-cbus GPIO pins
> 	- merged n8x0 board file changes into i2c-cbus patch
> 	- corrected typo in Kconfig for MFD_RETU
> 	- added power off functionality to retu-mfd
> 	- added IRQ functionality to retu-mfd
> 	- added power button key driver
> 	- some cleanups
> 
> Aaro Koskinen (4):
>   i2c: introduce i2c-cbus driver
>   mfd: introduce retu-mfd driver
>   watchdog: introduce retu_wdt driver
>   input: misc: introduce retu-pwrbutton

I had a look to the patches 1, 2 and 4, so for them

Reviewed-by: Andi Shyti <andi@etezian.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2IXJMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:12:09 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47098 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454Ab2IXJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:12:06 -0400
Date: Mon, 24 Sep 2012 11:12:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch v1 6/7] DA9055 Watchdog driver
Message-ID: <20120924091202.GE16482@spo001.leaseweb.com>
References: <1347629604.18587.19.camel@dhruva> <1348477700.1639.4.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348477700.1639.4.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish

> Any update on this patch?
> On Fri, 2012-09-14 at 19:03 +0530, Ashish Jangam wrote:
> > This is the Watchdog patch for the DA9055 PMIC. This patch has got
> > dependency on the DA9055 MFD core.
> > 
> > This patch is functionally tested on SMDK6410
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> >  drivers/watchdog/Kconfig      |   10 ++
> >  drivers/watchdog/Makefile     |    1 +
> >  drivers/watchdog/da9055_wdt.c |  227 +++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 238 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/watchdog/da9055_wdt.c

I'll review it tomorrow- or wednesday-evening. My first impression is that it looks OK.

Kind regards,
Wim.


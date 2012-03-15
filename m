Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2COVZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:25:37 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:38138 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753173Ab2COVZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:25:36 -0400
Date: Thu, 15 Mar 2012 22:25:34 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        David Dajun Chen <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com
Subject: Re: [PATCH 05/07] Watchdog: DA9052/53 watchdog support v1
Message-ID: <20120315212534.GG10698@spo001.leaseweb.com>
References: <1328532486.30549.82.camel@dhruva> <1331641624.7058.2.camel@dhruva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331641624.7058.2.camel@dhruva>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

> Any update on below patch?
> On Mon, 2012-02-06 at 18:18 +0530, Ashish Jangam wrote:
> > This driver adds support for the watchdog functionality provided by the
> > Dialog Semiconductor DA9052/53 PMIC chip.
> > 
> > This patch is functionally tested on Samsung SMDKV6410.
> > 
> > Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> >  Documentation/watchdog/watchdog-parameters.txt |    5 +
> >  drivers/watchdog/Kconfig                       |    6 +
> >  drivers/watchdog/Makefile                      |    1 +
> >  drivers/watchdog/da9052_wdt.c                  |  333 ++++++++++++++++++++++++
> >  4 files changed, 345 insertions(+), 0 deletions(-)

What's the difference with the version of Fri, 5 Aug 2011 19:21:51 +0530 ?

Kind regards,
Wim.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1B1ATm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 19:19:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:28782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1B1ATl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 19:19:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,236,1297065600"; 
   d="scan'208";a="607056508"
Date: Mon, 28 Feb 2011 01:19:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Bibek Basu <bibek.basu@stericsson.com>, dbrownell@users.sourceforge.net,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AB8500 GPIO : Driver for 42 AB8500 GPIO pins
Message-ID: <20110228001937.GC2749@sortiz-mobl>
References: <1297827283-22860-1-git-send-email-bibek.basu@stericsson.com>
 <1297827283-22860-2-git-send-email-bibek.basu@stericsson.com>
 <AANLkTi=n3=wu802DR3mn2oLgw8zYx+R0nE9rpn1curnH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=n3=wu802DR3mn2oLgw8zYx+R0nE9rpn1curnH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Feb 16, 2011 at 09:32:15AM +0100, Linus Walleij wrote:
> 2011/2/16 Bibek Basu <bibek.basu@stericsson.com>:
> 
> > To get rid of port expanders, the free GPIOs of ab8500
> > can be used. There are 42 GPIO pins. Out of which 16
> > are interrupt capable.This patch implements 16 virtual
> > IRQ mapped to 16 interrupt capable AB8500 GPIOs.
> >
> > Signed-off-by: Bibek Basu <bibek.basu@stericsson.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Sam, when/if this driver is OK with you I'd like to merge it
> through the ux500-core tree, so as to get platform data in at
> the same time, so request Acked-by: whenever you like it.
The MFD parts look fine:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

You probably want to get Grant to look at the GPIO parts though.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

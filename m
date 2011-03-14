Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab1CNSCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:02:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:36672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082Ab1CNSCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:02:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,317,1297065600"; 
   d="scan'208";a="720026952"
Date: Mon, 14 Mar 2011 19:02:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonas Aberg <jonas.aberg@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: add a core driver for TI TPS61050/TPS61052
 chips v2
Message-ID: <20110314180239.GQ31153@sortiz-mobl>
References: <1299672158-4711-1-git-send-email-linus.walleij@stericsson.com>
 <AANLkTi==Fj7g8ne9NxiAoPoWtKxEmJrd=Q4j--Y3A4cF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi==Fj7g8ne9NxiAoPoWtKxEmJrd=Q4j--Y3A4cF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Mar 14, 2011 at 05:40:14PM +0100, Linus Walleij wrote:
> On Wed, Mar 9, 2011 at 1:02 PM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
> 
> > From: Linus Walleij <linus.walleij@linaro.org>
> >
> > The TPS61050/TPS61052 are boost converters, LED drivers, LED flash
> > drivers and a simple GPIO pin chips.
> >
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Cc: Jonas Aberg <jonas.aberg@stericsson.com>
> > Cc: Ola Lilja <ola.o.lilja@stericsson.com>
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Sam, if you're happy with this MFD driver, I'd request you to merge this and the
> the regulator driver [2/3] into the MFD tree if possible. The ux500
> platform data
> will have to wait, since I have now sent that tree upstream.
I will be looking at it sometime later this week.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

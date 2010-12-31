Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0LaOLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:11:05 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:48398 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753367Ab0LaOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:11:03 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 31 Dec 2010 14:58:00 +0100
To: Trilok Soni <tsoni@codeaurora.org>
Cc: Kevin McNeely <kev@cypress.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 1/3] 1/3 Touchscreen: Cypress TTSP G3 MTDEV Core Driver
Message-ID: <20101231135800.GA1513@polaris.bitmath.org>
References: <kev@cypress.com>
 <1293650268-1561-1-git-send-email-kev@cypress.com>
 <20101231115323.GA9709@polaris.bitmath.org>
 <4D1DD2D7.30108@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1DD2D7.30108@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PYfUa-0007VV-69.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PYfUa-0007VV-69 49c3c61d7ddd61f5c560c6401ab7300b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 06:25:51PM +0530, Trilok Soni wrote:
> Hi Henrik,
> 
> On 12/31/2010 5:23 PM, Henrik Rydberg wrote:
> > Hi Kevin,
> > 
> > Thanks for the changes, it looks much better now. Some comments on the MT
> > part inline.
> > 
> >> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> >> index 06ea8da..7d886bc 100644
> >> --- a/drivers/input/touchscreen/Kconfig
> >> +++ b/drivers/input/touchscreen/Kconfig
> >> @@ -124,6 +124,11 @@ config TOUCHSCREEN_CY8CTMG110
> >>  	  To compile this driver as a module, choose M here: the
> >>  	  module will be called cy8ctmg110_ts.
> >>  
> >> +config TOUCHSCREEN_CYTTSP_CORE
> >> +	bool "Cypress TTSP touchscreen core"
> >> +	help
> >> +	  Always activated for Cypress TTSP touchscreen
> >> +
> > 
> > Tristate please.
> 
> This code is just exporting APIs and doesn't need to be modular. No module_init/exit etc.,

Any particular reason why "grep cytt /proc/kallsyms | wc" should be
non-zero when no suitable hardware is available?

Henrik

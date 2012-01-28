Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2A1Kl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 05:41:59 -0500
Received: from antcom.de ([188.40.178.216]:42101 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab2A1Kl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 05:41:58 -0500
Message-ID: <4F23D0EE.8000103@antcom.de>
Date: Sat, 28 Jan 2012 11:41:50 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: grant.likely@secretlab.ca, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>,
        bangaragiri.g@nxp.com, srinvas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com
Subject: Re: [PATCH] Fix LPC32XX's clock.c
References: <1327673868-19741-1-git-send-email-stigge@antcom.de> <20120127223211.GA27425@pengutronix.de>
In-Reply-To: <20120127223211.GA27425@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/12 23:32, Wolfram Sang wrote:
>> [clock.c]
> This needs to be split up further to make reviewing easier, I'd
> say. From a glimpse, I'd guess:
> 
> - locking changes - usb fixes - adding MLC NAND - adding ADC

OK, will separate things out. Can move over the changes for ADC and
MLC NAND to the respected driver integration patches (following).

> I dunno, maybe the NXP git has the incremental changes? You should
> really CC Kevin Wells on your patches. Maybe he will wake up again,
> at least with some additional informaition.

Yes, I'm also re-forwarding all my integration patches to Kevin Wells
and his colleagues at NXP who also committed to git.lpclinux.com in
the past.

The patches have different sources, all collected together now:

* http://git.lpclinux.com/ (Kevin Wells et. al., NXP), repositories:
  - linux-2.6.27.8-lpc32xx.git
  - linux-2.6.34-lpc32xx.git
  - linux-2.6.39.2-lpc.git
* http://git.antcom.de/ (my repos)
  - linux-2.6, branch work92105

I basically collected the most recent versions and fixes from the
other different sources together and forward-ported to latest Linux
mainline. (Currently works really well for the WORK Microwave devices
based on LPC3250.) You can find many incremental changes in the above
repositories hopefully clearing things up.

Thanks in advance,

Roland

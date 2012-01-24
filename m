Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab2AXUiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:38:06 -0500
Received: from antcom.de ([188.40.178.216]:40530 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab2AXUiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:38:04 -0500
Message-ID: <4F1F16A8.7010407@antcom.de>
Date: Tue, 24 Jan 2012 21:38:00 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120104 Icedove/8.0
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, Kevin Wells <kevin.wells@nxp.com>
Subject: Re: LPC32xx status (Re: [PATCH] Correct bad gpio naming)
References: <4F1C4E25.6070801@antcom.de> <20120124155921.GH2609@pengutronix.de> <4F1EDD15.7010704@antcom.de> <20120124192545.GB8502@pengutronix.de>
In-Reply-To: <20120124192545.GB8502@pengutronix.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/12 20:25, Wolfram Sang wrote:
>> Expect the first one of the drivers to be submitted soon, I will
>> do them one by one.
> 
> I think the first step should be adding a generic defconfig and
> make sure this builds and boots (I think I have a phy3250
> somewhere, so I could test). After that new drivers would make
> sense. IIRC clock.c was pretty broken, we needed hacks to get USB
> working with a 2.6.35. I also see that your tree modifies it.

I see that you are already at it ;-) - for the others: On the server
"git.antcom.de", I meant repository "linux-2.6.git", branch "work92105".

Unfortunately, I currently don't have a phy3250, but can check
tomorrow with colleagues.

I guess the work92105_defconfig is only useful once the drivers
currently missing in mainline are merged. Or is there an arm specific
tree I should update from?

Thanks in advance!

Roland

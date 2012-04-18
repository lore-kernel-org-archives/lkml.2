Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab2DRIeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:34:01 -0400
Received: from antcom.de ([188.40.178.216]:60922 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2DRId7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:33:59 -0400
Message-ID: <4F8E7C70.6090900@antcom.de>
Date: Wed, 18 Apr 2012 10:33:52 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20120216 Icedove/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 3/8] ARM: LPC32xx: clock.c update
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-4-git-send-email-stigge@antcom.de> <20120417210905.GJ6498@mwanda>
In-Reply-To: <20120417210905.GJ6498@mwanda>
X-Enigmail-Version: 1.3.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 11:09 PM, Dan Carpenter wrote:
> On Tue, Apr 17, 2012 at 07:08:22PM +0200, Roland Stigge wrote:
>> Besides switching to the default macro CLKDEV_INIT() for clock registration,
>> this patch actually updates the clock registrations of pl08xdmac.
>>
> 
> When there is a cleanup and a new feature added in the same patch,
> it makes it hard to read...  :/  So when we update pl08xdmac:
> 
> -       CLKDEV_INIT(NULL, "clk_dmac", &clk_dma),
> +       CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),
> 
> What does that actually do?  Is it a bug fix?

The primecell DMA driver refers to this clock via "pl08xdmac", so it
only works with the above line change. Will separate out to another patch.

Thanks,

Roland

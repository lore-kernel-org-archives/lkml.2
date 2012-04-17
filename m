Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2DQVHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 17:07:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30501 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2DQVHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 17:07:33 -0400
Date: Wed, 18 Apr 2012 00:09:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Subject: Re: [PATCH v2 3/8] ARM: LPC32xx: clock.c update
Message-ID: <20120417210905.GJ6498@mwanda>
References: <1334682507-15055-1-git-send-email-stigge@antcom.de>
 <1334682507-15055-4-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334682507-15055-4-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090208.4F8DDB74.00B3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 07:08:22PM +0200, Roland Stigge wrote:
> Besides switching to the default macro CLKDEV_INIT() for clock registration,
> this patch actually updates the clock registrations of pl08xdmac.
> 

When there is a cleanup and a new feature added in the same patch,
it makes it hard to read...  :/  So when we update pl08xdmac:

-       CLKDEV_INIT(NULL, "clk_dmac", &clk_dma),
+       CLKDEV_INIT("pl08xdmac", NULL, &clk_dma),

What does that actually do?  Is it a bug fix?

regards,
dan carpenter


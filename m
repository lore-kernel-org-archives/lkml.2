Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab2FNLYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:24:14 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:41549 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972Ab2FNLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-1-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:53:50 +0530
Message-ID: <CAMQu2gxG9ojz4fCCwdYQY8oYZyv0vu9oDuvhuPFVdY29F6w5=g@mail.gmail.com>
Subject: Re: [PATCH 00/17] Big OMAP I2C Cleanup
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi guys,
>
> I have dropped a few patches from the series and also
> tested every single patch on my pandaboard. I2C messages
> are still working fine with panda after each patch.
>
> There's still lots of work to be done on the i2c-omap.c
> driver but it's now easier to read, IMO.
>
Great cleanup. Have reviewed the entire series based on
limited knowledge i have about the OMAP i2c driver.
Apart from those comments, the series looks good to me.

We may to take similar dig at MMC and SPI driver one day :-p

Regards
santosh

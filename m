Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2IQHwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:52:43 -0400
Received: from void.printf.net ([89.145.121.20]:36577 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2IQHwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:52:42 -0400
From: Chris Ball <cjb@laptop.org>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: linux-mmc@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/3] mmc: davinci_mmc: convert to DMA engine API
References: <1345574589-24757-1-git-send-email-mporter@ti.com>
	<1345574589-24757-3-git-send-email-mporter@ti.com>
	<k139rl$gbm$2@ger.gmane.org>
Date: Mon, 17 Sep 2012 03:52:52 -0400
In-Reply-To: <k139rl$gbm$2@ger.gmane.org> (Koen Kooi's message of "Wed, 22 Aug
	2012 20:53:43 +0200")
Message-ID: <m3ipbdytkb.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 22 2012, Koen Kooi wrote:
> Op 21-08-12 20:43, Matt Porter schreef:
>> Removes use of the DaVinci EDMA private DMA API and replaces it with use
>> of the DMA engine API.
>> 
>> Signed-off-by: Matt Porter <mporter@ti.com>
>
> Runtime tested on hawkboard with 3.6.0-rc2 with rootfs on SD and running
> bonnie++ on it.
>
> Tested-by: Koen Kooi <koen@dominion.thruhere.net>

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

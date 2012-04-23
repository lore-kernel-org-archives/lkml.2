Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2DWJyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:54:39 -0400
Received: from 7.mo3.mail-out.ovh.net ([46.105.57.200]:51805 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226Ab2DWJyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:54:38 -0400
Date: Mon, 23 Apr 2012 11:35:00 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] net/at91_ether: use gpio_to_irq for phy IRQ line
Message-ID: <20120423093500.GG9142@game.jcrosoft.org>
References: <1335173852-582-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335173852-582-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2797016845295790956
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegtddrtdefucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeggedrtddtucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:37 Mon 23 Apr     , Nicolas Ferre wrote:
> Use the gpio_to_irq() function to retrieve the phy IRQ line
> from the GPIO pin specification.
> This fix is needed now that we have moved to irqdomains on AT91.
> 
> Reported-by: Jamie Iles <jamie@jamieiles.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Andrew Victor <avictor.za@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>  drivers/net/ethernet/cadence/at91_ether.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
I send a send a patch to cleanup the at91_ether please rebase over it

this patch is here  for a while

Best Regards,
J.

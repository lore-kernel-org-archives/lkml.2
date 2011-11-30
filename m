Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1K3Exx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:53:53 -0500
Received: from 6.mo3.mail-out.ovh.net ([188.165.43.173]:39855 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752176Ab1K3Exu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:53:50 -0500
Date: Wed, 30 Nov 2011 05:44:03 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: David Miller <davem@davemloft.net>
Cc: nicolas.ferre@atmel.com, jamie@jamieiles.com, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] at91_ether: use gpio_is_valid for phy IRQ line
Message-ID: <20111130044403.GY15008@game.jcrosoft.org>
References: <1322128098-17724-1-git-send-email-jamie@jamieiles.com>
 <1322169674-4109-1-git-send-email-nicolas.ferre@atmel.com>
 <20111129.185342.105454076866922618.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129.185342.105454076866922618.davem@davemloft.net>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13063816619271039781
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrtddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdttfdttdervdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefhedrtdelucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:53 Tue 29 Nov     , David Miller wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Thu, 24 Nov 2011 22:21:14 +0100
> 
> > Use the generic gpiolib gpio_is_valid() function to test
> > if the phy IRQ line GPIO is actually provided.
> > 
> > For non-connected or non-existing phy IRQ lines, -EINVAL
> > value is used for phy_irq_pin field of struct at91_eth_data.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> I'm assuming this goes through the ARM tree, because in both of my networking
> trees there is no ARM at91 implementation of gpio_is_valid().
yes the depending patch series is in the arm-soc

can we have your ack or sob?

Best Regards,
J.

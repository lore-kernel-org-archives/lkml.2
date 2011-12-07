Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1LGMR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:17:29 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:59496
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010Ab1LGMR1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:17:27 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 20:30:10 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <linux-arm-kernel@lists.infradead.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [MXS MMC 3/5] Add support for SSP/MMC ports 2 & 3
Message-ID: <20111207123008.GM5550@S2100-06.ap.freescale.net>
References: <cover.1323177907.git.LW@KARO-electronics.de>
 <e668bb1ab5fbe406ef604a18f59292a05149ae51.1323177907.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <e668bb1ab5fbe406ef604a18f59292a05149ae51.1323177907.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 02:41:28PM +0100, Lothar Waﬂmann wrote:
> i.MX28 has four SSP/MMC units, only two of which are currently
> usable.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Applied, thanks.

Please add prefix 'ARM: mxs:' or 'arm/mxs' to make the patch look like
the below in the future submission.

 [PATCH 3/5] ARM: mxs: Add support for SSP/MMC ports 2 & 3

I fixed it this time.

-- 
Regards,
Shawn


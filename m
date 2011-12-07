Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab1LGIOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:14:01 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:38439
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752660Ab1LGIN7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:13:59 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 16:26:44 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: set con_id
 in clk_get() call to NULL
Message-ID: <20111207082643.GB5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <6c28f25c5c6d2f88d0985ce361c5e16f19db27d0.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:10AM +0100, Lothar Waﬂmann wrote:
> The con_id is actually not needed for clk_get().
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Other than subject,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn


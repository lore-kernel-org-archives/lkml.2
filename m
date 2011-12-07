Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab1LGINQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:13:16 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:39036
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751826Ab1LGINP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:13:15 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275dhz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 7 Dec 2011 16:25:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH][NET] several cleanups and bugfixes for fec.c: misc
 cleanups
Message-ID: <20111207082557.GA5550@S2100-06.ap.freescale.net>
References: <cover.1323163127.git.LW@KARO-electronics.de>
 <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323163127.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <bd4415514fa0b40ece04d56b3ac4f549e79d87d7.1323163127.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:09AM +0100, Lothar Waﬂmann wrote:
>  - remove some bogus whitespace
>  - remove line wraps from printk messages
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Other than subject,

Acked-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1LHJEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:04:22 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:8893
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab1LHJEQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:04:16 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 8 Dec 2011 17:17:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [MXS MMC v2 2/4] Some cleanups for the MMC driver
Message-ID: <20111208091701.GC7913@S2100-06.ap.freescale.net>
References: <cover.1323328267.git.LW@KARO-electronics.de>
 <d935557e044d2ebc56b4e70487b519fe722e9017.1323328267.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <d935557e044d2ebc56b4e70487b519fe722e9017.1323328267.git.LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 09:17:45AM +0100, Lothar Waﬂmann wrote:
>  - Remove bogus parens around numerical arguments in #define's
>  - When defining bit masks, use the #def for the shift count
>    instead of repeating the numbers
>  - Remove 'break' at end of switch statement
> 
> Changes wrt v1:
>  - break long lines
>  - leave indentation as is
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Not sure if Chris will ask you to add proper subject prefix though :)

-- 
Regards,
Shawn


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab1LOI7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:59:35 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:24269 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752667Ab1LOI7d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:59:33 -0500
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzz8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 15 Dec 2011 17:08:05 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>, <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jason Liu <jason.hui@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] serial/imx: let probing fail for the dt case without a
 valid alias
Message-ID: <20111215090804.GC22541@S2101-09.ap.freescale.net>
References: <20111215021046.GD3259@S2101-09.ap.freescale.net>
 <1323936994-2250-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1323936994-2250-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:16:34AM +0100, Uwe Kleine-König wrote:
> When the uart device is instantiated by dt but dt doesn't provide an
> alias then better let probing fail instead of falling back to an
> unrelated device id used for the line number and no platform data.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---

Acked-by: Shawn Guo <shawn.guo@linaro.org>


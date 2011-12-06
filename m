Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab1LFBce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 20:32:34 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:18945 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab1LFBcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 20:32:33 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 6 Dec 2011 09:45:13 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Axel Lin <axel.lin@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH] spi/imx: simplify error handling to free gpios
Message-ID: <20111206014512.GG2980@S2100-06.ap.freescale.net>
References: <1323071228.20963.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323071228.20963.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:47:08PM +0800, Axel Lin wrote:
> Simplify the error handling by moving the code to free gpios in one place.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>

Regards,
Shawn


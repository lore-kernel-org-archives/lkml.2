Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2LYOK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:10:26 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:1031
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751604Ab2LYOKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:10:24 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 25 Dec 2012 22:10:23 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Torben Hohn <torbenh@linutronix.de>
CC: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Marek Vasut <marex@denx.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mxs timer: use ahbx bus clock to drive the timers on
 timrotv2
Message-ID: <20121225141020.GB25478@S2101-09.ap.freescale.net>
References: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
 <1356098776-10498-2-git-send-email-torbenh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1356098776-10498-2-git-send-email-torbenh@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 03:06:15PM +0100, Torben Hohn wrote:
> timer resolution of ~32us is pretty low.
> v2 has 32bits resolution, so we have quite some headroom, and
> can use the 24MHz clock.
> v1 has only 16bits, so we only increase v2.
> 
> So we just exchange the timrot clock in imx28.
> On imx23 we have timrotv1 and everything stays the same.
> 
> Signed-off-by: Torben Hohn <torbenh@linutronix.de>

1) s/ahbx/apbx on patch subject.
2) The patch prefix should look like "ARM: mxs: ..."

Fixed them and applied both patches.  Thanks.

Shawn


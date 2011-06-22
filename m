Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897Ab1FVCQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 22:16:16 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:56739
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757737Ab1FVCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 22:16:14 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Jun 2011 10:21:59 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Arnaud Patard <arnaud.patard@rtp-net.org>, <linux@arm.linux.org.uk>,
        <Dinh.Nguyen@freescale.com>, <linux-kernel@vger.kernel.org>,
        <ra5478@freescale.com>, <u.kleine-koenig@pengutronix.de>,
        <xiao-lizhang@freescale.com>, <festevam@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv7] ARM: mx51: Add support for low power suspend on MX51
Message-ID: <20110622022157.GA25234@S2100-06.ap.freescale.net>
References: <1301325297-24126-1-git-send-email-Dinh.Nguyen@freescale.com>
 <87k4cfa550.fsf@lebrac.rtp-net.org>
 <20110621223527.GF6069@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110621223527.GF6069@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 12:35:27AM +0200, Sascha Hauer wrote:
> On Tue, Jun 21, 2011 at 11:46:35AM +0200, Arnaud Patard wrote:
> > <Dinh.Nguyen@freescale.com> writes:
> > 
> > Hi,
> > 
> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > >
> > > Adds initial low power suspend functionality to MX51.
> > > Supports "mem" and "standby" modes.
> > >
> > > Tested on mx51-babbage.
> > >
> > > Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> > 
> > I fail to see this patch in imx tree. Did it get merged in some other
> > tree ?
> 
> Not yet. Have you tested this patch?
> 
I did.

Tested-by: Shawn Guo <shawn.guo@linaro.org>

-- 
Regards,
Shawn


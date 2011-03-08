Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1CHLkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 06:40:11 -0500
Received: from protonic.xs4all.nl ([213.84.116.84]:22498 "EHLO protonic.prtnl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753652Ab1CHLkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 06:40:08 -0500
Date: Tue, 8 Mar 2011 12:40:23 +0100
From: David Jander <david.jander@protonic.nl>
To: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
Cc: Nguyen Dinh-R00091 <R00091@freescale.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Message-ID: <20110308124023.5a952d13@archvile>
In-Reply-To: <20110307180700.GQ29521@pengutronix.de>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
	<56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
	<87oc5puwg3.fsf@lebrac.rtp-net.org>
	<56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
	<87fwqyvrzf.fsf@lebrac.rtp-net.org>
	<56132A77AB93C141BF06E6B96CA6CFEA1940F8@039-SN1MPN1-004.039d.mgd.msft.net>
	<20110307180700.GQ29521@pengutronix.de>
Organization: Protonic Holland
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Sascha,

On Mon, 7 Mar 2011 19:07:00 +0100
"s.hauer@pengutronix.de" <s.hauer@pengutronix.de> wrote:
>[...]
> > The current imx for-next tree is not booting on my Babbage board. Is
> > it okay for you with your HW. I'll have to debug the booting part
> > first.
> 
> Probably because other than kconfig states i.MX51 and i.MX53 cannot be
> compiled in one kernel. the for-next branch boots fine on my babbage.

Would you mind explaining (or pointing to an explanation) as to why this is
not supposed to work? Given the high level of compatibility between MX51 and
MX53, I'd say there must be a very good reason not to enable a single binary
kernel for both. Or is this just temporary brokenness?

Best regards,

-- 
David Jander
Protonic Holland.

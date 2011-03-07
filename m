Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1CGSHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 13:07:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34965 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab1CGSHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 13:07:07 -0500
Date: Mon, 7 Mar 2011 19:07:00 +0100
From: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Message-ID: <20110307180700.GQ29521@pengutronix.de>
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
 <56132A77AB93C141BF06E6B96CA6CFEA19124C@039-SN1MPN1-004.039d.mgd.msft.net>
 <87oc5puwg3.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA193F14@039-SN1MPN1-004.039d.mgd.msft.net>
 <87fwqyvrzf.fsf@lebrac.rtp-net.org>
 <56132A77AB93C141BF06E6B96CA6CFEA1940F8@039-SN1MPN1-004.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56132A77AB93C141BF06E6B96CA6CFEA1940F8@039-SN1MPN1-004.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:05:53 up 19 days,  6:03, 31 users,  load average: 5.33, 4.23,
 2.80
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:35:48PM +0000, Nguyen Dinh-R00091 wrote:
> Hi Arnaud,
> 
> 
> >-----Original Message-----
> >From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
> >bounces@lists.infradead.org] On Behalf Of Arnaud Patard
> >Sent: Monday, March 07, 2011 10:02 AM
> >To: Nguyen Dinh-R00091
> >Cc: linux@arm.linux.org.uk; s.hauer@pengutronix.de; linux-kernel@vger.kernel.org; Vaidyanathan
> >Ranjani-RA5478; u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; linux-arm-
> >kernel@lists.infradead.org
> >Subject: Re: [PATCHv2 1/2] ARM: mx51: Implement code to allow mx51 to enter WFI
> >
> >Nguyen Dinh-R00091 <R00091@freescale.com> writes:
> >
> >> Hi Arnaud,
> >
> >Hi,
> >>
> >> Just to verify that you are testing on an MX51-Babbage board? Here's my log:
> >
> >I never said I was testing on babbage. The reason is because I'm using a
> >efika smartbook and not a babbage.
> >
> >>
> >> root@freescale ~$ uname -a
> >> Linux freescale 2.6.38-rc1+ #93 Fri Mar 4 17:18:15 CST 2011 armv7l GNU/Linux
> >
> >2.6.38-rc1+ ? which tree are you using ? The for-next branch of Sascha
> >Hauer's tree is at least 2.6.38-rc5 so you're trying to merge something
> >without even testing it on the current tree. Can you please test suspend
> >with current imx for-next tree (with no other patches than theses 2
> >patches if possible), in order to make sure that it's still working with it ?
> >
> 
> The current imx for-next tree is not booting on my Babbage board. Is
> it okay for you with your HW. I'll have to debug the booting part
> first.

Probably because other than kconfig states i.MX51 and i.MX53 cannot be
compiled in one kernel. the for-next branch boots fine on my babbage.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

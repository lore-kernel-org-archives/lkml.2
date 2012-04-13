Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab2DMUSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:18:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47850 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab2DMUSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:18:49 -0400
Date: Fri, 13 Apr 2012 22:18:43 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        linaro-dev@lists.linaro.org, Anish Trivedi <anish@freescale.com>,
        rtc-linux@googlegroups.com, patches@linaro.org,
        linux-kernel@vger.kernel.org, Eric Miao <eric.miao@linaro.org>,
        Anson Huang <b20788@freescale.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] rtc: add support for Freescale SNVS RTC
Message-ID: <20120413201843.GF20478@pengutronix.de>
References: <1332162269-16789-1-git-send-email-paul.liu@linaro.org>
 <20120322151156.GF2213@S2101-09.ap.freescale.net>
 <4F88515A.2020805@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F88515A.2020805@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:14:07 up 153 days,  4:01, 24 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 12:16:26AM +0800, Ying-Chun Liu (PaulLiu) wrote:
> > 
> > I haven't completely understood this, and will need more study.
> > 
> 
> Hi Shawn,
> 
> About the above ioctl() related blocks. I think it is used by some user
> space libs that requires accurate time (47BIT TIME). And it have to be
> sure that the time continuously flowing so the apps wants to be notified
> that the rtc is changed dramatically by the set command.
> 
> I'm guessing that it might be related to the Multimedia binary libs. A/V
> sync or something like that. But I don't have those source code. Please
> make sure those libs are not using it.
> 
> I also see other Freescale RTC driver implement the same function. For
> example:
> http://tinyurl.com/cnp93jv
> So I guess it might be a common ioctl that Freescale uses somewhere.
> 
> So my plan is to split the IOR to a header file. And keep the rest as is.

'think', 'might' and 'something like that' are the wrong words to
convince anybody that these ioctls are needed. So unless you find real
usecases and also can convince us that it's not possible to reach your
goal using either the existing ioctls or an additional common (non fsl
specific) ioctl please just drop them.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

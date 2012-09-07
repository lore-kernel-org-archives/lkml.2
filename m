Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2IGROY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:14:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50259 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IGROV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:14:21 -0400
Date: Fri, 7 Sep 2012 19:14:11 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-arm-kernel@lists.infradead.org,
        HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-15?Q?Beno=EEt_Th=E9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH v3] pwm i.MX: add devicetree support
Message-ID: <20120907171411.GT26594@pengutronix.de>
References: <1346935695-25179-1-git-send-email-s.hauer@pengutronix.de>
 <20120907131037.GD29340@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120907131037.GD29340@avionic-0098.mockup.avionic-design.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:13:08 up 76 days,  8:24, 42 users,  load average: 1.54, 1.33,
 1.23
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 03:10:37PM +0200, Thierry Reding wrote:
> On Thu, Sep 06, 2012 at 02:48:06PM +0200, Sascha Hauer wrote:
> > The following is the third version of the i.MX pwm series. I integrated
> > the remaining comments from Shawn and Benoît and added their tags.
> > 
> > So Thierry, please pull the attached patches. The pull request only
> > contains the pwm framework specific patches, the remaining two I'd
> > like to push via the arm-soc tree in case the i.MX5 also gets devicetree
> > clock lookups.
> 
> Hi Sascha,
> 
> Sorry for taking so long to get back to you. Apart from my comments to
> patch 1, I really like how this series cleans up the i.MX driver. It's
> already a bit late in the 3.6 release cycle for these kinds of changes
> and none of them fix any regressions, so I'd like to queue them for
> 3.7 after my comments have been addressed.

Sure, no problem. The patches were never intended to go in for 3.6. I
will address your comments and resend on monday.

Thanks
 Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

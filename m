Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab1JGMxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 08:53:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49053 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951Ab1JGMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 08:52:59 -0400
Date: Fri, 7 Oct 2011 14:52:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Philippe =?iso-8859-15?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Fabio Estevam <festevam@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Message-ID: <20111007125254.GY21769@pengutronix.de>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
 <20111003130409.GA2487@xps8300>
 <CAOMZO5DwDiBa_Ksow5bt02S_zMMEn4uB_hz-5KS+dyNiZA88sQ@mail.gmail.com>
 <201110041905.59247.philippe.retornaz@epfl.ch>
 <20111005095114.GB7594@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111005095114.GB7594@xps8300>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:52:10 up 107 days, 18:39, 36 users,  load average: 0.89, 2.36,
 1.37
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 12:51:14PM +0300, Heikki Krogerus wrote:
> On Tue, Oct 04, 2011 at 07:05:58PM +0200, Philippe Rétornaz wrote:
> > Tested on mx31moboard-marxbot, works fine (ie, nothing changed).
> 
> Thanks Philippe. I assume we can add:
> 
> Tested-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
> 
> Sascha, I still would like you to test these, as you found the issues
> in the v4.

Compiles and works fine on a i.MX27 board.

Tested-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

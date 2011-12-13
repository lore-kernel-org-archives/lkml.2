Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1LMKRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:17:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44756 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1LMKRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:17:44 -0500
Date: Tue, 13 Dec 2011 11:17:31 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Li Yang <leoli@freescale.com>,
        Felipe Balbi <balbi@ti.com>,
        "open list:FREESCALE USB PER..." <linux-usb@vger.kernel.org>,
        "open list:FREESCALE USB PER..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/19] mxc_udc: add workaround for ENGcm09152 for i.MX25
Message-ID: <20111213101731.GI27267@pengutronix.de>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:54 up 30 days, 17:56, 25 users,  load average: 0.00, 0.05,
 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

To make the handling of your patches easier, please

- send a cover letter for multiple patches
- separate them at least by fixes and features
- if possible, do not send patches aimed at multiple
  maintainers in a single series.

I picked every patch looking like a fix for now myself,
but please remember next time. I'll have a look at the non-fix
patches later.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

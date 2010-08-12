Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab0HLPpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:45:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933808Ab0HLPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:45:42 -0400
Date: Thu, 12 Aug 2010 17:45:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 11/13] usb gadget: don't save bind callback in struct
	usb_composite_driver
Message-ID: <20100812154539.GA12912@pengutronix.de>
References: <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com> <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com> <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com> <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com> <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com> <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com> <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com> <ad117de19af4733f113c8631e53556cc308dbf06.1281625724.git.m.nazarewicz@samsung.com> <340f780f91de1b3ca17d0c29d87963205d172f4e.1281625724.git.m.nazarewicz@samsung.com> <cfb1102e8bd59822b76475d58f5e4f1ceadade50.1281625724.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfb1102e8bd59822b76475d58f5e4f1ceadade50.1281625724.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 05:43:54PM +0200, Michal Nazarewicz wrote:
> The bind function is most of the time only called at init time so there
> is no need to save a pointer to it in the composite driver structure.
> 
> This fixes many section mismatches reported by modpost.
> 
> Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Ack

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

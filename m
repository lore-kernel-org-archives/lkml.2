Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0JTNZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:25:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab0JTNZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:25:50 -0400
Date: Wed, 20 Oct 2010 15:25:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        Zhang Lily-R58066 <R58066@freescale.com>, valentin.longchamp@epfl.ch
Subject: Re: [PATCH] ARM: imx: change mx51.h into mx5x.h
Message-ID: <20101020132549.GB19834@pengutronix.de>
References: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com> <20101020090122.GH28166@pengutronix.de> <20101020113550.GL2562@matterhorn.lan> <20101020130903.GA19834@pengutronix.de> <86A0E76937111F4C92FABEC0A2098851051D5B0F@az33exm21>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86A0E76937111F4C92FABEC0A2098851051D5B0F@az33exm21>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 20, 2010 at 06:15:53AM -0700, Nguyen Dinh-R00091 wrote:
> I guess I should also ask this question now. I was planning to add
> support for mx53 kernel that will be binary compatible with mx51. I'm
> guessing that you are not in support of that idea?
With "binary compatible" you mean you want to build a kernel that runs
on both, mx51 and mx53 machines?  Yes, I definitly want that, that's one
of the main reasons to do that consolidation.

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

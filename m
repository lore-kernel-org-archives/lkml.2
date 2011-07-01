Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1GASd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:33:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43045 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab1GASdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:33:23 -0400
Date: Fri, 1 Jul 2011 20:33:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: AT91: Fix pull requset
Message-ID: <20110701183313.GV11559@pengutronix.de>
References: <20110701065411.GD14408@game.jcrosoft.org>
 <201107011709.40359.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201107011709.40359.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 05:09:40PM +0200, Arnd Bergmann wrote:
> On Friday 01 July 2011, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > HI Linus, Russell, Arnd
> For every bug fix you commit, please check if it applies to older
> kernels as well, and mark with 'Cc: stable@kernel.org' if so. Do you
> want to update the changelog and send another pull request?
Or alternatively (i.e. if you don't want to rewrite your tree) just
writing to stable@kernel.org and indicating the upstream commit ids is
usually OK, too.
The other extreme is to point out the affected versions, e.g. by using 

	Cc: stable@kernel.org [2.6.xy+]

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

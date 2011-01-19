Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1ASHn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 02:43:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1ASHn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 02:43:58 -0500
Date: Wed, 19 Jan 2011 08:43:55 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Nick Piggin <npiggin@gmail.com>
Cc: maciej.rutecki@gmail.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: BUG: spinlock recursion (sys_chdir, user_path_at,
 do_path_lookup ...)
Message-ID: <20110119074355.GF10686@pengutronix.de>
References: <20110111110539.GP24920@pengutronix.de>
 <201101181759.32013.maciej.rutecki@gmail.com>
 <AANLkTikC0ZV6pZ7jVmZ5DSrrkPCN4UPn3VY+zM2RWSc6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikC0ZV6pZ7jVmZ5DSrrkPCN4UPn3VY+zM2RWSc6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:19:59AM +1100, Nick Piggin wrote:
> 2011/1/19 Maciej Rutecki <maciej.rutecki@gmail.com>:
> > I created a Bugzilla entry at
> > https://bugzilla.kernel.org/show_bug.cgi?id=27032
> > for your bug report, please add your address to the CC list in there, thanks!
> 
> Sorry I missed this mail. This bug should have been fixed several
> days ago 90dbb77ba48dddb87445d238e84cd137cf97dd98
Yesterday I retryed Linus' tree (which has the commit 90dbb77ba) and the
spinlock recursion is gone.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0FOJWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:22:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41743 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab0FOJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:22:33 -0400
Date: Tue, 15 Jun 2010 11:22:30 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stefani@seibold.net
Subject: Re: [PATCH] tags: put function prototypes back!
Message-ID: <20100615092230.GA21819@pengutronix.de>
References: <20100203201816.GA5987@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100203201816.GA5987@x200>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:18:17PM +0200, Alexey Dobriyan wrote:
> commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
> "ctags: usability fix" removed function prototypes from tags file
> claiming "It makes no real sense to include function prototypes".
> But it is useful for quickly determining which header file developer
> needs to include to fix compilation.
> 
> Now if someone wants to remove forward declatations (which I agree are
> baggage), write a postprocessing script.
> 
> Please apply.
> 
> 	Alexey, who is sick reverting this chunk locally.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

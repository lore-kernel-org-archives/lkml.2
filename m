Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab0FOLlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:41:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48429 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab0FOLlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:41:18 -0400
Date: Tue, 15 Jun 2010 13:41:08 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: Re: [PATCH] tags: put function prototypes back!
Message-ID: <20100615114108.GD21709@pengutronix.de>
References: <20100203201816.GA5987@x200> <20100615092230.GA21819@pengutronix.de> <4C174DBB.9000901@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C174DBB.9000901@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 11:54:03AM +0200, Michal Marek wrote:
> On 15.6.2010 11:22, Uwe Kleine-König wrote:
> > On Wed, Feb 03, 2010 at 10:18:17PM +0200, Alexey Dobriyan wrote:
> >> commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
> >> "ctags: usability fix" removed function prototypes from tags file
> >> claiming "It makes no real sense to include function prototypes".
> >> But it is useful for quickly determining which header file developer
> >> needs to include to fix compilation.
> >>
> >> Now if someone wants to remove forward declatations (which I agree are
> >> baggage), write a postprocessing script.
> >>
> >> Please apply.
> >>
> >> 	Alexey, who is sick reverting this chunk locally.
> >>
> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Alexey, can you please resend the patch? I don't see it in the archives
> anywhere.

Gmane supports getting mails by Message-Id:

	http://mid.gmane.org/20100203201816.GA5987@x200

redirects to http://article.gmane.org/gmane.linux.kernel/946067,
appending raw is nearly suitable for usage by mutt.

{ echo From lala Mon Sep 17 00:00:00 2001; wget -O - http://article.gmane.org/gmane.linux.kernel/946067/raw; } > patch

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

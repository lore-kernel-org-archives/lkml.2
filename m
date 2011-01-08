Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1AHQYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 11:24:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49084 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1AHQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 11:24:17 -0500
Date: Sat, 8 Jan 2011 17:24:05 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>, Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@linux.intel.com,
        akpm@linux-foundation.org, jonas.aberg@stericsson.com, julia@diku.dk,
        xiyou.wangcong@gmail.com, yann.morin.1998@anciens.enib.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild misc updates for 2.6.38-rc1
Message-ID: <20110108162405.GD8237@pengutronix.de>
References: <20110107230426.GA15371@sepie.suse.cz>
 <20110107232754.GB8237@pengutronix.de>
 <4D27A329.7010801@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D27A329.7010801@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal, hi Alexey,

On Sat, Jan 08, 2011 at 12:35:05AM +0100, Michal Marek wrote:
> On 8.1.2011 00:27, Uwe Kleine-König wrote:
> > Hi Michal,
> > 
> > On Sat, Jan 08, 2011 at 12:04:26AM +0100, Michal Marek wrote:
> >> Uwe Kleine-König (1):
> >>       tags: put function prototypes back!
> > this is wrong.  It was Alexey who authored that patch.  I only pinged
> > and forwarded it a few times.
> 
> Grr. You should added a second From: header to the message body in that
> case, git am supports this. Rewinding the branch while Linus is possibly
> reviewing it might not be a great idea. Alexey, how much would it hurt
> you if the commit stayed as is?
hmm, actually I know that, and wonder why send-email didn't add it.

... some research ...  strange, in my repo I'm already the author for
this patch.  So it seems the error is really on my side.  I don't
remember but I guess git-am failed for me and then I commited without
taking care to keep the original author.  @Alexey: sorry for messing
this up.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

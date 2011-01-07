Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1AGX2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 18:28:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56524 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab1AGX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:28:07 -0500
Date: Sat, 8 Jan 2011 00:27:54 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ak@linux.intel.com,
        akpm@linux-foundation.org, jonas.aberg@stericsson.com, julia@diku.dk,
        xiyou.wangcong@gmail.com, yann.morin.1998@anciens.enib.fr,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT] kbuild misc updates for 2.6.38-rc1
Message-ID: <20110107232754.GB8237@pengutronix.de>
References: <20110107230426.GA15371@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110107230426.GA15371@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Sat, Jan 08, 2011 at 12:04:26AM +0100, Michal Marek wrote:
> Uwe Kleine-König (1):
>       tags: put function prototypes back!
this is wrong.  It was Alexey who authored that patch.  I only pinged
and forwarded it a few times.

If you care to fix that:

	git filter-branch --env-filter 'if test "x$GIT_COMMIT" = "x0a18a9386c056028799938960f91be338c4ff349"; then GIT_AUTHOR_NAME="Alexey Dobriyan"; GIT_AUTHOR_EMAIL=adobriyan@gmail.com; export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL; fi' v2.6.37-rc1..misc

.  This is untested though, so you might want to double check the
result.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

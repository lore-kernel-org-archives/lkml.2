Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2GXNwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:52:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36642 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754124Ab2GXNwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:52:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ywTNBgwhyVf4vcpqoQ4zT5Y22+HNMdQO41XBwyY
	zui7DOPff0IRqp
Message-ID: <1343137938.7412.95.camel@marge.simpson.net>
Subject: Re: [PATCH 00/34] Memory management performance backports for
 -stable V2
From: Mike Galbraith <efault@gmx.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Stable <stable@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 24 Jul 2012 15:52:18 +0200
In-Reply-To: <CAJd=RBC835W52nsXCqhM_4KR3CuLF9zijh3416LiJLybTuR_YA@mail.gmail.com>
References: <1343050727-3045-1-git-send-email-mgorman@suse.de>
	 <1343109531.7412.47.camel@marge.simpson.net>
	 <CAJd=RBC835W52nsXCqhM_4KR3CuLF9zijh3416LiJLybTuR_YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 21:18 +0800, Hillf Danton wrote: 
> On Tue, Jul 24, 2012 at 1:58 PM, Mike Galbraith <efault@gmx.de> wrote:
> > FWIW, I'm all for performance backports.  They do have a downside though
> > (other than the risk of bugs slipping in, or triggering latent bugs).
> >
> > When the next enterprise kernel is built, marketeers ask for numbers to
> > make potential customers drool over, and you _can't produce any_ because
> > you wedged all the spiffy performance stuff into the crusty old kernel.
> >
> Well do your job please.
> 
> 	Suse 11 SP1 kernel panic on HP hardware
> 	https://lkml.org/lkml/2012/7/24/136

Last time I looked, handling SUSE support issues on LKML was not in my
job description.  I don't recall seeing anything about taking direction
from random LKML subscribers either.

-Mike


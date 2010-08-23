Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0HWV2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:28:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56109 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754670Ab0HWV2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:28:36 -0400
Date: Mon, 23 Aug 2010 14:28:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
Message-Id: <20100823142816.59b12253.akpm@linux-foundation.org>
In-Reply-To: <20100823204829.GB6510@console-pimps.org>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
	<AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
	<m3pqxbsibq.fsf@pullcord.laptop.org>
	<20100823204829.GB6510@console-pimps.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 21:48:29 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> On Sat, Aug 21, 2010 at 06:37:45PM -0400, Chris Ball wrote:
> > Hi,
> > 
> >    > Hm is there some problem with this patch or has the processing of
> >    > it simply stalled? When I read the thread I cannot see Hanumaths
> >    > answers on the list but it looks mainly like the patch is OK and
> >    > there is some chit-chat.
> >    > 
> >    > Can it be picked up? Everyone is going to need DDR MMC for their
> >    > eMMCs soon-ish.
> > 
> > I'd like to dedicate more time to mmc/.  Do you think it'd be useful
> > for me to catch all the patches sent to linux-mmc@ into a public Git
> > tree, and periodically report on what went upstream via akpm and
> > what's still waiting?
> 
> It's possible Andrew has a reason that hasn't been picked up yet.
> 

Kyungmin Park's questions didn't seem adequately answered and the
discussion kind of died.

I updated the patch and merged it, but I'd like the outstanding
question(s) resolved.  ie: why do we add MMC_DDR_MODE, set it in
brq.data.flags and then never use it?



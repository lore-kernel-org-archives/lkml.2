Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab0HZVUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 17:20:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45767 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0HZVUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 17:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hGnDNAldMjx2iUnzFwP+1MxAYcGaZ4nmnr89LYxbULtsMYYcvNRgI1rxEiCOB/PJJ5
         ujYjyPBN39uzZc9fzoi/TQeAY2ZgquTl14TgfX4TAu7U6RW6c5yEfKP3ipBm3C7I6PJj
         5JnX1vroy9o3y+yMYedyy3ZsFav3Kv/OF0t9I=
Date: Fri, 27 Aug 2010 01:20:25 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] gpio: Add driver for Anton GPIO controllers
Message-ID: <20100826212025.GA3366@oksana.dev.rtsoft.ru>
References: <20100826172602.GA20410@oksana.dev.rtsoft.ru>
 <488952.94429.qm@web180312.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <488952.94429.qm@web180312.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 10:57:33AM -0700, David Brownell wrote:
[...]
> Not that I want to be naming this, but how
> about a tweak to Alan's suggestion, keeping
> the name technical?
> 
>    "gpio_basic_mmio.c" ... or similar?

I would agree yesterday, but now I tend to like
anton_gpio.c. :-D

You seemed to be fine with meaningless amba-9999
or dw_abc names, but now, when I propose such a
marvellous name, you seem to lean to a synonym of
an old one, the one that I used in v1? Wouldn't
it be a step backwards? :-)

Just kiding, of course. basic_mmio.c works for me.

I also think it makes sense to drop gpio_ prefix,
as the driver is already in gpio/ directory.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0HWUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:48:34 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39250 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753021Ab0HWUsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:48:32 -0400
Date: Mon, 23 Aug 2010 21:48:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Chris Ball <cjb@laptop.org>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>, linux-mmc@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
Message-ID: <20100823204829.GB6510@console-pimps.org>
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
 <AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
 <m3pqxbsibq.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3pqxbsibq.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 06:37:45PM -0400, Chris Ball wrote:
> Hi,
> 
>    > Hm is there some problem with this patch or has the processing of
>    > it simply stalled? When I read the thread I cannot see Hanumaths
>    > answers on the list but it looks mainly like the patch is OK and
>    > there is some chit-chat.
>    > 
>    > Can it be picked up? Everyone is going to need DDR MMC for their
>    > eMMCs soon-ish.
> 
> I'd like to dedicate more time to mmc/.  Do you think it'd be useful
> for me to catch all the patches sent to linux-mmc@ into a public Git
> tree, and periodically report on what went upstream via akpm and
> what's still waiting?

It's possible Andrew has a reason that hasn't been picked up yet.

Maybe what we really need is to get patchwork setup for the linux-mmc
list? Other subsystem maintainers swear by it. That way, it'd be much
harder for patches to go unnoticed.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab2IFAnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:43:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39532 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755275Ab2IFAnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:43:03 -0400
Date: Thu, 6 Sep 2012 08:42:57 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH -next] soc: fix wm0010.c printk format warning
Message-ID: <20120906004251.GV10580@opensource.wolfsonmicro.com>
References: <20120905161230.3bab1de6d4c8c8e466c3b0df@canb.auug.org.au>
 <5047DF49.6070502@xenotime.net>
 <20120906000612.GO10580@opensource.wolfsonmicro.com>
 <5047EA1C.7080608@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047EA1C.7080608@xenotime.net>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 05:11:08PM -0700, Randy Dunlap wrote:
> On 09/05/2012 05:06 PM, Mark Brown wrote:

> > Somone already sent this.  As ever please try to use subject lines
> > appropriate for the subsystem.  Please also consider who you're CCing -

> Unfortunately the MAINTAINERS file does not tell me what to include
> in the $subject line for the subsystem.
> What would you like to see there, please?  Maybe ASoC?

As with every other subsystem in the kernel look at the log for the
thing your changing and do something that visually resembles it.  If you
want get_maintainers to do this for you you'll need to write the code
(or convince someone else to do it).

> > there's no need to copy -next on things like this which aren't

> I have always done a reply-to-all for linux-next patches, so after
> a few years someone days Don't Do That (IYO).

I'm pretty sure I've mentioned this before...  actually, if you're
relying on get_maintainers that's probably some of the false positives
too.  If you've found an issue related to the -next integration that's
one thing but if you've just noticed a random thing in the kernel that
could be improved that's not really something about -next.

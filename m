Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0F1Qvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:51:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38157 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0F1Qvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WH1WHH4akaIPUY1eiyiqJhCc5YNwl5OJ0+gYqDYo9KNp8InjamcX1HQdHzn/QF5ZVG
         8Q++tnagQ8vkkNi2rx9E5L+t2Y4JRChW+Vx8ZUXuXNanCt07FrpzULV7+r0CtZ92Qp9Z
         dYZCiAfywmdsGL96KQl+xL6SsWjoQSeqlMv3g=
Date: Mon, 28 Jun 2010 09:51:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: ps2mouse not working in 2.6.34
Message-ID: <20100628165138.GD11670@core.coreip.homeip.net>
References: <4C28C81E.4010909@teksavvy.com>
 <4C28CF16.30904@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C28CF16.30904@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 12:34:30PM -0400, Mark Lord wrote:
> On 28/06/10 12:04 PM, Mark Lord wrote:
> >Okay, who broke it, and how do I re-enable it?
> >
> >The PS/2 mice on my systems here don't do anything with 2.6.34.
> >One system complains that I need to boot with i8042.nopnp to enable it,
> >which I also tried, but still nogo. Same behaviour with or without
> >/dev/psaux enabled. 64-bit kernel.
> >
> >The other system, running older userspace, hangs at the X-server startup
> >because it cannot find the mouse. No i8042 warnings. 32-bit kernel.
> >
> >Both systems working fine with older kernels.
> >Google finds lots of other people discovering the same problem.
> >
> >What gives?
> ..
> 
> Mmmm.. the problem started for some people with 2.6.32:
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/587134

When did it start for _you_? I really do not know what kernel and
patches are in Lucid so I'd much more prefer knowing the vanilla kernel
version - I could at least see what has been changed there.

Are you also using USB-to-PS/2 converter?

Probably if you boot with i8042.debug and post full dmesg we coudl see
what is going on there...

> 
> That thread has a suggestion that perhaps
>    "the kernel fails to properly set the power settings for the PS2 port"
> 
> Whatever that means.  :)

I have no idea either.

-- 
Dmitry

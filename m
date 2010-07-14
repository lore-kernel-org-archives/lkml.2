Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0GNGlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:41:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52995 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0GNGls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:41:48 -0400
Date: Wed, 14 Jul 2010 08:41:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: peter@piie.net
Cc: Branislav Gajdos <brianzee@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: acerhdf.c - unsupported notebook
Message-ID: <20100714064141.GA5076@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, peter@piie.net,
	Branislav Gajdos <brianzee@gmail.com>, linux-kernel@vger.kernel.org
References: <AANLkTin0mv0Z5vozJHkfVYCJTWMvj9JZnP_FcQ6vZBRV@mail.gmail.com>
 <20100713124840.GA16427@a1.tnic>
 <AANLkTimBhWKo0zxW6fX5RgLLAQVIdItS5RKpvxqkDlis@mail.gmail.com>
 <20100713151329.GA17516@a1.tnic>
 <cone.1279041124.439539.3902.1000@deskpiie>
 <AANLkTimiZcGY04wDK0yLtGrDknP-amyUaWybqsD5DHqC@mail.gmail.com>
 <20100713204235.GA32085@liondog.tnic>
 <20100714072012.21363okof2qiqomc@webmail.df.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714072012.21363okof2qiqomc@webmail.df.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: peter@piie.net
Date: Wed, Jul 14, 2010 at 07:20:12AM +0200

> >>So that means you would keep there the definitions for Core 2 based
> >>models as well, right?
> 
> The 1810's are already supported by acerhdf and some people use it
> for fan control, so we should keep it, but we should enhance the
> bios_tbl by "default_fanon" and "default_fanoff". What do you think
> Boris?

Sure, we definitely need to do that, and more specifically:

1) we have to check first with how many different types of cpus are the
1810s being shipped and

2) whether the thermal settings of those cpus differ

because if they do, you need to check for cpu types also and not only
bios version and product info, which can get very hairy very fast.

And for all those thermal settings we need official documentation and
cannot accept any other sources.

That's why I keep questioning whether it makes sense for 1810 users (or
users of something else besides acer aspire netbooks with atom cpus, for
that matter) to use this driver.

> >You still didn't answer my question whether your fan is noisy? IOW, does
> >it make sense for you to use this driver at all?
> 
> Haven't got any email from a 3810 user to add support for this
> model, so for me it seems like the fan isn't noisy at all. - Usually
> as soon as a new model with a noisy fan comes out the people are
> spaming my inbox and crying ;)

What models are those, are those only aspire one netbooks or anything
else acer dumps out?

Bottom line is: I'm trying to understand what this driver should and
should not support? Frankly, I don't want to make it easy for users
to do fan control and break their hardware while doing so. Actually,
if acer's system builders would've done their job right in picking a
quieter fan for their packaging we wouldn't be talking here in the first
place. For example, I have also a lenovo edge and I almost can't hear
the fan there but that's a different story.

See what I'm sayin'?

-- 
Regards/Gruss,
    Boris.

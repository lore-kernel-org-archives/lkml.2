Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab0KJVH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:07:29 -0500
Received: from www.tglx.de ([62.245.132.106]:41387 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab0KJVH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:07:27 -0500
Date: Wed, 10 Nov 2010 22:07:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maciej Szmigiero <mhej@o2.pl>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Ben Nizette <bn@niasdigital.com>
Subject: Re: [GPIO]implement sleeping GPIO chip removal
In-Reply-To: <4CDB0834.4080101@o2.pl>
Message-ID: <alpine.LFD.2.00.1011102203500.2900@localhost6.localdomain6>
References: <4CD6F049.10102@o2.pl> <20101110050947.GC4110@angua.secretlab.ca> <4CDABA03.2050000@o2.pl> <alpine.LFD.2.00.1011102134350.2900@localhost6.localdomain6> <4CDB0834.4080101@o2.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please use a mail client which does proper line breaks at 78 ?

On Wed, 10 Nov 2010, Maciej Szmigiero wrote:
> You misunderstood me.

No, I didnt.

> By "looping in hope that somebody will finally release the chip" I
> meant the only real way to handle a GPIO chip unplugging in the
> current kernel.  Which is way worse that preventing new requests,
> then waiting for existing one to be released.  And this is exactly
> what my patch does.

That still does not make it a good solution.

> I understand that it could be simplified by removing redundant code
> (as Grant Likely had suggested before), and moving it to completion
> interface instead of manipulating a task structure directly, but
> this doesn't mean that the whole GPIO code has to be rewritten just
> to add one functionality.

It's not about rewriting, it's about fixing the problem in the right
way and not just hacking around it.

If we see a shortcoming like this, we fix it and do not magically work
around it.

Thanks,

	tglx

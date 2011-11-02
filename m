Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1KBJGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 05:06:11 -0400
Received: from void.printf.net ([89.145.121.20]:38578 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391Ab1KBJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 05:06:07 -0400
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, "Gutierrez\, Juan" <jgutierrez@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-mmc@vger.kernel.org,
        Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [GIT PULL] hwspinlock changes for 3.2
References: <CAK=WgbZso1qk5XUTjB1bLXYbezv80SbgyEXJ3Q32U28+cQMfZA@mail.gmail.com>
	<CAK=Wgbb9yfFeubc8jfTe5urMz4WoCpOL=LwP9=Lr7mYaWrt1Vw@mail.gmail.com>
Date: Wed, 02 Nov 2011 05:05:03 -0400
In-Reply-To: <CAK=Wgbb9yfFeubc8jfTe5urMz4WoCpOL=LwP9=Lr7mYaWrt1Vw@mail.gmail.com>
	(Ohad Ben-Cohen's message of "Wed, 2 Nov 2011 09:45:11 +0200")
Message-ID: <m2ehxqao8w.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 02 2011, Ohad Ben-Cohen wrote:
> There also seems to be a (trivial) omap_hsmmc build issue which I've
> fixed and pushed to that branch (Chris I'm also attaching it below in
> case you prefer to take it through the mmc tree).

I already have it in mmc-next, but it's fine to send it through your
branch instead:

Acked-by: Chris Ball <cjb@laptop.org>

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

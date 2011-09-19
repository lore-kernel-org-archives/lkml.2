Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1ISIsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:48:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1ISIsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:48:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Greg KH <greg@kroah.com>, Jean Delvare <khali@linux-fr.org>,
        Luciano Coelho <coelho@ti.com>, matti.j.aaltonen@nokia.com,
        johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
Date: Mon, 19 Sep 2011 10:47:50 +0200
Message-ID: <2282172.TF7nejTDIZ@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E763C3C.3050909@xenotime.net>
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <20110918152835.GA30696@kroah.com> <4E763C3C.3050909@xenotime.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ME4aDg3y/lvMXd8zaS5Ba8YeuGMHOzxjks1+Vun9v3+
 8THH1HnwUO0gqLnnOjGYqt9PTCE5TfWwkyVK8LTmvGlIlramg5
 4uPPHDu8Dxe3b2OAd1KIe2bhUaa/xT7JWSU4bSUYQxKPYP36bY
 ANLhfxKWB4RIVl3M7h2e0KZM5jphWHN86N8f8U2vdo3r+eI7ao
 zt2ZFh6shmzZeGIeJFE1Z4ud+wS0TiXYyXmvWx88A3zAn1owvf
 HmtCphZ2fObDIG9GqotlkvvDAUjtFCZcI33t1L7MglDNVrqtB8
 /d1mcoWC1WjqDpxcTHp8mI0sCvD1pz9/+fJ5lHHOD7lHm188tR
 FHidcO8Ay4C1MhNjwuuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 September 2011 11:45:16 Randy Dunlap wrote:
> >> We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
> >> consistent or timely with applying drivers/misc/ patches.  It deserves better.
> >> [added him to Cc: list]
> > 
> > I do try to handle patches sent to me for misc/ in time for the
> > different merge windows as that directory contains drivers that have
> > moved out of the staging/ directory.
> > 
> > But yes, I'm not the overall drivers/misc/ maintainer, do we really need
> > one?  If so, I can easily start maintaining a development tree for it to
> > keep it separate for the different driver authors to send me stuff and
> > start tracking it more "for real" if Arnd doesn't want to do it.
> 
> We need for the patches to be applied in a timely manner.
> Sometimes when there is no real maintainer, that does not happen.

I think the other equally import aspect of maintainership that
drivers/misc (and drivers/char) needs is someone who says no to
stuff that doesn't belong there and helps submitters to find a
proper place where appropriate and to come up with a proper user
interface abstraction.

I'm definitely willing to do that part.

Greg, how about we both formally take ownership of driver/{misc,char}
and you track the patches while I do the bulk of the reviews? You
are definitely better than me with the patch tracking workflow.

	Arnd

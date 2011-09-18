Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab1IRPLu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 11:11:50 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:55110 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755314Ab1IRPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 11:11:47 -0400
Message-ID: <4E760A31.8030807@xenotime.net>
Date: Sun, 18 Sep 2011 08:11:45 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean Delvare <khali@linux-fr.org>, Luciano Coelho <coelho@ti.com>,
        matti.j.aaltonen@nokia.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] misc: remove CONFIG_MISC_DEVICES
References: <20110829102732.03f0f05d.rdunlap@xenotime.net> <201109021643.14275.arnd@arndb.de> <20110905144134.2c80c4b9@endymion.delvare> <201109051619.35553.arnd@arndb.de>
In-Reply-To: <201109051619.35553.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2011 07:19 AM, Arnd Bergmann wrote:
> I think it would simply be more consistent to have it enabled all
> the time. Well, even better would be to move the bulk of the misc
> drivers to a proper location sorted by their subsystems. A lot of them
> should never have been merged in their current state IMHO.


If it's clear where they belong, then sure, they should be somewhere
other than drivers/misc/, but I don't see that it's clear for several
of them.


> I think I should finally do what has been  talked about a few times and
> formally become the maintainer of drivers/char and drivers/misc ;-)
> 
> The problem is that I'm not actually a good maintainer, but maybe it's
> better to just have someone instead of falling back to Andrew or
> some random subsystem maintainer to send any patches for drivers/misc.

We have fallbacks to Andrew and/or GregKH currently, but GregKH is not
consistent or timely with applying drivers/misc/ patches.  It deserves better.
[added him to Cc: list]

So yes, I think that drivers/misc/ (and probably drivers/char/) deserves
a maintainer, but you are not making a good case for you being that person.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

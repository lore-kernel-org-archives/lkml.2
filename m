Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0LAUl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:41:56 -0500
Received: from mail.atheros.com ([12.19.149.2]:58691 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149Ab0LAUly convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:41:54 -0500
Date: Wed, 1 Dec 2010 12:41:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Joe Perches <joe@perches.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "peter@stuge.se" <peter@stuge.se>
Subject: Re: [ath9k-devel] [PATCH wireless-next] MAINTAINERS: Add ATH
 GENERIC UTILITIES
Message-ID: <20101201204149.GC2359@tux>
References: <20101129060732.5130.qmail@stuge.se>
 <4CF42C17.2070500@openwrt.org>
 <1291081185.16349.133.camel@Joe-Laptop>
 <4CF464D6.2020507@openwrt.org>
 <1291148375.18026.342.camel@Joe-Laptop>
 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
 <1291225075.1845.177.camel@Joe-Laptop>
 <AANLkTinU+jWBXUdW2v9WSL2SZWQn8FHai4+=dAPTASe6@mail.gmail.com>
 <1291234615.1845.196.camel@Joe-Laptop>
 <AANLkTim+ayPBhBiKtuhgxKt645YT_o=5w_ckrq71j-ES@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTim+ayPBhBiKtuhgxKt645YT_o=5w_ckrq71j-ES@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 12:18:30PM -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 1, 2010 at 12:16 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2010-12-01 at 11:46 -0800, Luis R. Rodriguez wrote:
> >> On Wed, Dec 1, 2010 at 9:37 AM, Joe Perches <joe@perches.com> wrote:
> >> > This file pattern is not currently shown as maintained
> >> > by atheros.  Perhaps it should be?
> >> > Signed-off-by: Joe Perches <joe@perches.com>
> >> Sure but its maintained by the community and Atheros hackers, not just me.
> >
> > No doubt.
> >
> > $ git log next-20101130 -- drivers/net/wireless/ath/*.[ch] | \
> >        grep -P "(^Author)" | cut -f2- -d":" | sort | uniq -c | sort -rn | head
> >     27  Luis R. Rodriguez <lrodriguez@atheros.com>
> >      6  Felix Fietkau <nbd@openwrt.org>
> >      4  Bruno Randolf <br1@einfach.org>
> >      3  Sujith <Sujith.Manoharan@atheros.com>
> >      3  John W. Linville <linville@tuxdriver.com>
> >      3  Joe Perches <joe@perches.com>
> >      3  Bob Copeland <me@bobcopeland.com>
> >      2  Pavel Roskin <proski@gnu.org>
> >      2  Johannes Berg <johannes@sipsolutions.net>
> >      2  David S. Miller <davem@davemloft.net>
> >
> > Without any sort of MAINTAINERS entry, the results
> > for files in that directory are like this:
> >
> > $ ./scripts/get_maintainer.pl -f --rolestats drivers/net/wireless/ath/main.c
> > "John W. Linville" <linville@tuxdriver.com> (maintainer:NETWORKING [WIREL...)
> > linux-wireless@vger.kernel.org (open list:NETWORKING [WIREL...)
> > netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
> > linux-kernel@vger.kernel.org (open list)
> >
> > Perhaps you want to be cc'd?
> > Perhaps there are atheros lists that should be cc'd?
> > If cc'ing linux-wireless is good enough,
> > that's good enough for me too.
> 
> OK you're patch is fine then.

But you sent it as part of an old thread, not sure if John will see it.

  Luis

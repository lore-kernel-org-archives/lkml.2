Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab0LAUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:16:59 -0500
Received: from mail.perches.com ([173.55.12.10]:2085 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919Ab0LAUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:16:57 -0500
Subject: Re: [PATCH wireless-next] MAINTAINERS: Add ATH GENERIC UTILITIES
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinU+jWBXUdW2v9WSL2SZWQn8FHai4+=dAPTASe6@mail.gmail.com>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
	 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
	 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
	 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>
	 <1291148375.18026.342.camel@Joe-Laptop>
	 <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
	 <1291225075.1845.177.camel@Joe-Laptop>
	 <AANLkTinU+jWBXUdW2v9WSL2SZWQn8FHai4+=dAPTASe6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:16:55 -0800
Message-ID: <1291234615.1845.196.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 11:46 -0800, Luis R. Rodriguez wrote:
> On Wed, Dec 1, 2010 at 9:37 AM, Joe Perches <joe@perches.com> wrote:
> > This file pattern is not currently shown as maintained
> > by atheros.  Perhaps it should be?
> > Signed-off-by: Joe Perches <joe@perches.com>
> Sure but its maintained by the community and Atheros hackers, not just me.

No doubt.

$ git log next-20101130 -- drivers/net/wireless/ath/*.[ch] | \
	grep -P "(^Author)" | cut -f2- -d":" | sort | uniq -c | sort -rn | head
     27  Luis R. Rodriguez <lrodriguez@atheros.com>
      6  Felix Fietkau <nbd@openwrt.org>
      4  Bruno Randolf <br1@einfach.org>
      3  Sujith <Sujith.Manoharan@atheros.com>
      3  John W. Linville <linville@tuxdriver.com>
      3  Joe Perches <joe@perches.com>
      3  Bob Copeland <me@bobcopeland.com>
      2  Pavel Roskin <proski@gnu.org>
      2  Johannes Berg <johannes@sipsolutions.net>
      2  David S. Miller <davem@davemloft.net>

Without any sort of MAINTAINERS entry, the results
for files in that directory are like this:

$ ./scripts/get_maintainer.pl -f --rolestats drivers/net/wireless/ath/main.c
"John W. Linville" <linville@tuxdriver.com> (maintainer:NETWORKING [WIREL...)
linux-wireless@vger.kernel.org (open list:NETWORKING [WIREL...)
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

Perhaps you want to be cc'd?
Perhaps there are atheros lists that should be cc'd?
If cc'ing linux-wireless is good enough,
that's good enough for me too.

cheers, Joe


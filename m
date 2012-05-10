Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2EJG5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:57:02 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:57506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2EJG5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:57:00 -0400
Message-ID: <1336633015.4334.2.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Date: Thu, 10 May 2012 08:56:55 +0200
In-Reply-To: <1336632860.22495.6.camel@joe2Laptop> (sfid-20120510_085441_236331_94537C40)
References: <cover.1336538937.git.joe@perches.com>
	 <20120509.212110.437114897180819434.davem@davemloft.net>
	 (sfid-20120510_032248_153593_581BC374) <1336632528.4334.1.camel@jlt3.sipsolutions.net>
	 <1336632860.22495.6.camel@joe2Laptop>
	 (sfid-20120510_085441_236331_94537C40)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 23:54 -0700, Joe Perches wrote:
> On Thu, 2012-05-10 at 08:48 +0200, Johannes Berg wrote:
> > On Wed, 2012-05-09 at 21:21 -0400, David Miller wrote:
> > 
> > > That case you didn't convert in mac80211 is probably the
> > > bug Johannes was talking about which started this whole
> > > discussion.
> > 
> > The bug case that started it all is in net/wireless/scan.c and Emmanuel
> > has since changed it back to memcmp(). Not sure if that's the one you
> > were referring to or not :-)
> 
> That's the one that I left alone.
> 
> Post patch:
> $ git grep -n -w compare_ether_addr net
> net/batman-adv/main.h:198: * note: can't use compare_ether_addr() as it requires aligned memory
> net/wireless/scan.c:381:        return compare_ether_addr(a->bssid, b->bssid);

Ok, great, then that means the fix from Emmanuel won't conflict when it
gets in.

johannes


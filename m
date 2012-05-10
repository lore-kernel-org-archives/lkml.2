Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab2EJGs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:48:58 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:56716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2EJGs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:48:56 -0400
Message-ID: <1336632528.4334.1.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH 00/13] net: Add and use ether_addr_equal
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date: Thu, 10 May 2012 08:48:48 +0200
In-Reply-To: <20120509.212110.437114897180819434.davem@davemloft.net> (sfid-20120510_032248_153593_581BC374)
References: <cover.1336538937.git.joe@perches.com>
	 <20120509.212110.437114897180819434.davem@davemloft.net>
	 (sfid-20120510_032248_153593_581BC374)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 21:21 -0400, David Miller wrote:

> That case you didn't convert in mac80211 is probably the
> bug Johannes was talking about which started this whole
> discussion.

The bug case that started it all is in net/wireless/scan.c and Emmanuel
has since changed it back to memcmp(). Not sure if that's the one you
were referring to or not :-)

johannes


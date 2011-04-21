Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1DUDk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:40:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700Ab1DUDk6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:40:58 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110419201048.281575300@clark.kroah.org>
References: <20110419201048.281575300@clark.kroah.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 21 Apr 2011 04:40:46 +0100
Message-ID: <1303357246.3464.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [48/70] vmscan: all_unreclaimable() use
 zone->all_unreclaimable as a name
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-19 at 13:08 -0700, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 929bea7c714220fc76ce3f75bef9056477c28e74 upstream.
> 
> all_unreclaimable check in direct reclaim has been introduced at 2.6.19
> by following commit.
> 
> 	2006 Sep 25; commit 408d8544; oom: use unreclaimable info
> 
> And it went through strange history. firstly, following commit broke
> the logic unintentionally.
> 
> 	2008 Apr 29; commit a41f24ea; page allocator: smarter retry of
> 				      costly-order allocations
[...]

So presumably this needs to be fixed in 2.6.32.y and other longterm
series as well.  Though there seems to be a whole series of fixes
required in 2.6.32.y!

Are you going to look after that, or should someone else prepare
backports?  (I'm certainly not volunteering - I don't have the VM
knowledge to work out what needs doing.)

Ben.

-- 
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

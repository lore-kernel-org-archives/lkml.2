Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab1HXGIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:08:06 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:46689 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1HXGID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:08:03 -0400
Subject: Re: b43 crash with fragmented packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1314163238.4478.8.camel@edumazet-laptop> (sfid-20110824_074509_254388_9F8F7B58)
References: <1314152883.4573.0.camel@jlt3.sipsolutions.net>
	 <1314163238.4478.8.camel@edumazet-laptop>
	 (sfid-20110824_074509_254388_9F8F7B58)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 23:08:15 -0700
Message-ID: <1314166095.4719.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 07:20 +0200, Eric Dumazet wrote:
> Le mardi 23 août 2011 à 19:28 -0700, Johannes Berg a écrit :
> > Just had a crash in mac80211 with an apparently fragmented packet
> > (segfault in ieee80211_rx_h_defragment), I can send the stacktrace but I
> > can't make much sense of it -- anyone see something similar?
> > 
> 
> 
> 
> Send it, preferably to netdev, since its probably more suited ;)

Err, I guess I messed up, I meant to send this to linux-wireless, sorry
folks.

johannes


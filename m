Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab0GBOPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 10:15:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49068 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab0GBOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 10:15:11 -0400
Date: Fri, 2 Jul 2010 10:08:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2010-07-01
Message-ID: <20100702140805.GA2381@tuxdriver.com>
References: <20100701181526.GA2356@tuxdriver.com>
 <20100701.173550.172604489.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701.173550.172604489.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:35:50PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Thu, 1 Jul 2010 14:15:27 -0400
> 
> > Two weeks since the last request, plenty of new stuff intended for
> > 2.6.36...
> > 
> > Included are the usual bunch of driver updates, including a big
> > dump from the rt2x00 team.  This also includes cfg80211 support
> > for libertas, a flurry of (mostly trivial) stuff from me, and a
> > wireless-2.6 pull to resolve some patch dependencies.
> > 
> > Please let me know if there are problems!
> 
> This failed to pull cleanly, I got a conflict in
> drivers/net/wireless/libertas/host.h  It was the
> usual "__packed" vs. "__attribute__((packed))" thing.
> 
> I resolved it but I wonder if this happened because you
> did the wireless-2.6 --> wireless-next-2.6 merge here.

Sorry, Dave!  I probably should have done 'for-davem' branch for you.
Thanks for resolving it!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

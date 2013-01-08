Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3AHUOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:14:20 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:37010 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748Ab3AHUOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:14:19 -0500
Date: Tue, 8 Jan 2013 20:14:19 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ppoll() stuck on POLLIN while TCP peer is sending
Message-ID: <20130108201419.GA30568@dcvr.yhbt.net>
References: <20121228014503.GA5017@dcvr.yhbt.net>
 <20130102200848.GA4500@dcvr.yhbt.net>
 <20130104160148.GB3885@suse.de>
 <20130106120700.GA24671@dcvr.yhbt.net>
 <20130107122516.GC3885@suse.de>
 <20130107223850.GA21311@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107223850.GA21311@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Mel Gorman <mgorman@suse.de> wrote:
> > Right now it's difficult to see how the capture could be the source of
> > this bug but I'm not ruling it out either so try the following (untested
> > but should be ok) patch.  It's not a proper revert, it just disables the
> > capture page logic to see if it's at fault.
> 
> Things look good so far with your change.
> It's been running 2 hours on a VM and 1 hour on my regular machine.
> Will update again in a few hours (or sooner if it's stuck again).

Things still seem good on my regular machine.

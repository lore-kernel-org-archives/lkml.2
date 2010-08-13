Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0HMH33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 03:29:29 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:5766 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0HMH3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 03:29:24 -0400
Date: Fri, 13 Aug 2010 01:29:20 -0600
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: Re: [PATCH 00/15] hpwdt: make NMI code a config option (+ other
 cleanup)
Message-ID: <20100813072920.GB21527@ldl.fc.hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
 <20100805214102.GA4288@infomag.iguana.be>
 <20100806212648.GA30843@infomag.iguana.be>
 <20100806212933.GA10779@ldl.fc.hp.com>
 <20100811124911.GH4288@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811124911.GH4288@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 02:49:11PM +0200, Wim Van Sebroeck wrote:
> Hi Dan,
> 
> > > watchdog: hpwdt (10/12): Construct status message w/ kasprintf and emit it with dev_info
> > > watchdog: hpwdt (11/12): Use "decoding" instead of "sourcing"
> > > watchdog: hpwdt (12/12): Make NMI decoding a compile-time option
> > > 
> > > (patch 12 can still be improved).
> > 
> > Thanks! I'll work on the #ifdef'ing & get you a new #12
> 
> I did some changes in the last 3 patches:
> I removed patch 10, made patch 11 patch 10 and added and extra patch that moves the nmi decoding init and exit functions in seperate modules.
> I'll sent you the 3 new patches. Just let me know if they are OK.

Yes, they look very much like the changes I was preparing - but I got
sidetracked by vacation before I could test :) I pulled your tree &
ran a few sanity tests - looks good. Thanks for doing this!


-- 
dann frazier | ProLiant Linux

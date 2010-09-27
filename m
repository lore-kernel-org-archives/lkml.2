Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab0I0Po5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:44:57 -0400
Received: from thunk.org ([69.25.196.29]:59846 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754Ab0I0Po4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:44:56 -0400
Date: Mon, 27 Sep 2010 11:44:41 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Florian Mickler <florian@mickler.org>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: RFC: get_maintainer.pl: append reason for cc to the name by
 default
Message-ID: <20100927154441.GE3602@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Florian Mickler <florian@mickler.org>,
	Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org
References: <1284111212-10659-1-git-send-email-florian@mickler.org>
 <1285527125.1732.24.camel@Joe-Laptop>
 <20100927165748.354742f2@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927165748.354742f2@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 04:57:48PM +0200, Florian Mickler wrote:
> 
> Would in essence have the same effect, but I think it's slightly better
> to have some shorter tags in the mail addresses, as I expect them to
> actually show up on lkml quite a bit.

What if there are no tags on mail addresses that come from the
MAINTAINERS file, but only tags on the mail addresses that come from
guessing wildly based on git sign-offs?  People should just be looking
in the MAINTAINERS file, after all, and I don't think that's something
that needs an explanation.

The thing that needs explanation is when someone like Steve Hemminger
gets cc'ed on a patch for fs/ext4/acl.c, which really makes no sense
at all, where you desperately need some kind of tag:

shemminger@vyatta.com (Wild guess using get_maintainer.pl --git)

	      	    	  			  - Ted

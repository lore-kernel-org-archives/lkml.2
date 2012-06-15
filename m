Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2FOX3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:29:53 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:50775 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab2FOX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:29:51 -0400
Date: Fri, 15 Jun 2012 18:50:57 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, libertas-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 00/20] Use pr_<level>
Message-ID: <20120615225057.GD7363@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Joe Perches <joe@perches.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	libertas-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <cover.1339739415.git.joe@perches.com>
 <1339745811.4512.0.camel@jlt3.sipsolutions.net>
 <1339757319.24527.21.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339757319.24527.21.camel@joe2Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:48:39AM -0700, Joe Perches wrote:
> To tee up conversions of:
> 	pr_<level>("%s: ...", ([truct netdevice *]foo)->name, ...)
> to
> 	netdev_<level>(foo, "...", ...) 

If the goal is to do the latter, why introduce needless patch churn
now just to get to pr_<level>?  Having a standardized netdev_<label>()
adds real benefit that can be weighed against the cost of code churn.
Why not just wait until the netdev_<level> infrastructure can be
introduced?  It will save effort on everybody's part.

	     	     	  	    		- Ted

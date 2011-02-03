Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1BCAGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 19:06:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53374 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab1BCAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 19:06:33 -0500
Date: Thu, 3 Feb 2011 01:06:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "javier@cozybit.com" <javier@cozybit.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] [128/139] mac80211: fix mesh forwarding
Message-ID: <20110203000630.GJ15569@one.firstfloor.org>
References: <20110201443.618138584@firstfloor.org> <20110202004527.B26AE3E09BD@tassilo.jf.intel.com> <1296633374.3624.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296633374.3624.1.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 08:56:14AM +0100, Johannes Berg wrote:
> On Wed, 2011-02-02 at 00:45 +0000, Andi Kleen wrote:
> 
> > -			if (!fwd_skb && net_ratelimit())
> > +			if (!fwd_skb && net_ratelimit()) {
> >  				printk(KERN_DEBUG "%s: failed to clone mesh frame\n",
> >  						   sdata->name);
> > +				goto out;
> > +			}
> 
> The net_ratelimit() here cause an obvious bug that I missed and a patch
> for that was submitted later -- you may want to pick that one up and/or
> fold it in (commit 919bbad580445801c22ef6ccbe624551fee652bd).

Added thanks.
-Andi

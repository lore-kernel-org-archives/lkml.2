Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759844Ab0KRQha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:37:30 -0500
Received: from kroah.org ([198.145.64.141]:36748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab0KRQh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:37:28 -0500
Date: Thu, 18 Nov 2010 08:36:53 -0800
From: Greg KH <greg@kroah.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        balbir@linux.vnet.ibm.com
Subject: Re: [stable] [PATCH] Make swap accounting default behavior
 configurable
Message-ID: <20101118163653.GA2786@kroah.com>
References: <20101116101726.GA21296@tiehlicka.suse.cz>
 <20101116124615.978ed940.akpm@linux-foundation.org>
 <20101116212157.GB9359@kroah.com>
 <20101118082132.GA15928@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118082132.GA15928@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:21:32AM +0100, Michal Hocko wrote:
> > Sorry, I really don't want to start backporting features to stable
> > kernels if at all possible.  Distros can pick them up on their own if
> > they determine it is needed.
> 
> I really do agree with the part about features. But isn't this patch
> basically for distros (to help them to provide the swapaccounting feature
> without the cost of higher memory consumption in default configuration)?

Then if the distros want it, they can pick it up themselves.

> If this doesn't go to the stable then all (interested) of them would
> need to maintain the patch. Otherwise the change would come directly
> from the upstream.

They can cherry-pick from upstream like they do for everything else, no
real change here.

> Moreover, it is not a new feature it just consolidates the default
> behavior of the already existing functionality.

Again, it doesn't match up with the stable kernel rules, sorry, no, this
is not a bugfix or regression.

thanks,

greg k-h

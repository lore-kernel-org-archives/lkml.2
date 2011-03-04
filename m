Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab1CDA3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 19:29:43 -0500
Received: from kroah.org ([198.145.64.141]:51598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab1CDA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 19:29:42 -0500
Date: Thu, 3 Mar 2011 16:18:26 -0800
From: Greg KH <greg@kroah.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, stable@kernel.org,
        linux-mm@kvack.org
Subject: Re: stable: mm: vmstat: use a single setter function and callback
 for adjusting percpu thresholds
Message-ID: <20110304001826.GA2429@kroah.com>
References: <20110303110324.GH14162@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303110324.GH14162@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 11:03:24AM +0000, Mel Gorman wrote:
> Edmund Nadolski reported the same problem Kosaki did against the commit
> [88f5acf8: mm: page allocator: adjust the per-cpu counter threshold when
> memory is low] whereby kswapd was in an inconsistent locking state due
> to calling get_online_cpus(): See https://lkml.org/lkml/2011/3/2/398 for
> details. This is already fixed upstream by commit [b44129b3: mm: vmstat: use
> a single setter function and callback for adjusting percpu thresholds]. Unless
> there is an objection, can this be picked up for 2.6.37-stable please?
> Ideally it would apply against 2.6.36.x as well but that release is no
> longer maintained.

Now queued up, thanks.

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab0FKVXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:23:42 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:39120 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab0FKVXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:23:40 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANdFEkyrRN+K/2dsb2JhbACefHGlFplqhRgEg0w
X-IronPort-AV: E=Sophos;i="4.53,405,1272844800"; 
   d="scan'208";a="334299257"
Date: Fri, 11 Jun 2010 14:23:37 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: to@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 3/4 v3][RFC] Infrastructure for compact call location
	representation
Message-ID: <20100611212336.GB30404@dvomlehn-lnx2.corp.sa.net>
References: <20100611203356.GA28446@dvomlehn-lnx2.corp.sa.net> <20100611134300.4a14c505.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100611134300.4a14c505.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 01:43:00PM -0700, Randy Dunlap wrote:
> On Fri, 11 Jun 2010 13:33:56 -0700 David VomLehn wrote:
> 
> > This patch allows the location of a call to be recorded as a small integer,
> > with each call location ("callsite") assigned a new value the first time
> > the code in that location is executed. Locations can be recorded as a
> > an address or as a __FILE__/__LINE__ pair. The later is easier to read, but
> > requires significantly more space.
> 
> Did you happen to look at what drivers/base/power/trace.c does for callsite
> recording?

No, but at one point I did have a similar implementation working. I moved
away from it because I was leery of add yet another section to vmlinux.lds.S
for such a narrow range of functionality. If adding a section makes sense
to others, I'll do it since I felt it was overall a better solution.

-- 
David VL

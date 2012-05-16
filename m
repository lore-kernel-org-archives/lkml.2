Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2EPQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:09:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:38192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab2EPQJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="144742192"
Date: Wed, 16 May 2012 12:10:20 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120516161020.GJ22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
 <1337149453.1961.24.camel@slavad-ubuntu-11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337149453.1961.24.camel@slavad-ubuntu-11>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:24:13AM +0400, Vyacheslav Dubeyko wrote:
> On Tue, 2012-05-15 at 09:34 -0400, Matthew Wilcox wrote:
> > There are a number of interesting non-volatile memory (NVM) technologies
> > being developed.  Some of them promise DRAM-comparable latencies and
> > bandwidths.  At Intel, we've been thinking about various ways to present
> > those to software.
> 
> Could you please share vision of these NVM technologies in more details?
> What capacity in bytes of of one NVM unit do we can expect? What about
> bad blocks and any other reliability issues of such NVM technologies?

No, I can't comment on any of that.  This isn't about any particular piece
of technology; it's an observation that there are a lot of technologies
that seem to fit in this niche; some of them are even available to
buy today.

No statement of mine should be taken as an indication of any future
Intel product plans :-)


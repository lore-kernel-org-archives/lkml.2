Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2IEJTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:19:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54008 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2IEJTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:19:31 -0400
Date: Wed, 5 Sep 2012 02:19:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, lennart@poettering.net,
        kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905091925.GJ3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471782.6060800@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50471782.6060800@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:12:34PM +0400, Glauber Costa wrote:
> > No, I never counted out differing granularity.
> 
> Can you elaborate on which interface do you envision to make it work?
> They will clearly be mounted in the same hierarchy, or as said
> alternatively, comounted.

I'm not sure yet.  At the simplest, mask of controllers which should
honor (or ignore) nesting beyond the node.  That should be
understandable enough.  Not sure whether that would be flexible enough
yet tho.  In the end, they should be comounted but again I don't think
enforcing comounting at the moment is a step towards that.  It's more
like a step sideways.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2IEJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:15:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2IEJPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:15:03 -0400
Date: Wed, 5 Sep 2012 02:14:56 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        davej@redhat.com, ben@decadent.org.uk, a.p.zijlstra@chello.nl,
        pjt@google.com, lennart@poettering.net, kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905091456.GI3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50471379.3060603@parallels.com>
 <20120905090744.GG3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047161F.60503@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047161F.60503@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 01:06:39PM +0400, Glauber Costa wrote:
> > Heh, this is tricky to describe and I'm not really following what you
> > mean. 
> 
> Do we really want to start cleaning up all this by changing the
> interface to something that is described as "tricky" ?

The concept is not tricky.  I just can't find the appropriate words.
I *suspect* this can mostly re-use the existing css_set thing.  It
mostly becomes that css_set belongs to the unified hierarchy rather
than each task.  The user interface part isn't trivial and maybe
"don't nest beyond this level" is the only thing reasonable.  Not sure
yet whether that would be enough tho.  Need to think more about it.

Thanks.

-- 
tejun

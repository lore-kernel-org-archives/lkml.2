Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2IEJLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:11:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63413 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab2IEJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:11:46 -0400
Date: Wed, 5 Sep 2012 02:11:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, lennart@poettering.net,
        kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346835993.2600.9.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
> *confused* I always thought that was exactly what you meant with unified
> hierarchy.

No, I never counted out differing granularity.

> Doing all this runtime is just going to make the mess even bigger,
> because now we have to deal with even more stupid cases.
> 
> So either we go and try to contain this mess as proposed by Glauber or
> we go delete controllers.. I've had it with this crap.

If cpuacct can really go away, that's great, but I don't think the
problem at hand is unsolvable, so let's not jump it.  cpuacct and cpu
aren't the onlfy problem cases after all.  We need to solve it for
other controllers too.

Thanks.

-- 
tejun

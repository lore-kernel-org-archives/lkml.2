Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab2IEJWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:22:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60002 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371Ab2IEJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:22:21 -0400
Date: Wed, 5 Sep 2012 02:22:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, davej@redhat.com,
        ben@decadent.org.uk, pjt@google.com, lennart@poettering.net,
        kay.sievers@vrfy.org
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Message-ID: <20120905092216.GK3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
 <1346836041.2600.10.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346836041.2600.10.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Sep 05, 2012 at 11:07:21AM +0200, Peter Zijlstra wrote:
> Glauber, the other approach is sending a patch that doesn't touch
> cgroup.c but only the controllers and I'll merge it regardless of what
> tj thinks.
> 
> We need some movement here.

Peter, I don't think the proposed patch is helpful at this point.
While movement is necessary, it's not like moving towards any
direction is helpful.  They might just become another cruft which
needs to be maintained.

Thanks.

-- 
tejun

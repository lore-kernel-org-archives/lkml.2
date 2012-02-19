Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2BSO5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:57:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab2BSO5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:57:31 -0500
Message-ID: <1329663435.24041.3.camel@cr0>
Subject: Re: [PATCH 01/60] highmem: mark k[un]map_atomic() with two
 arguments as deprecated
From: Cong Wang <amwang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>,
        Nick Bowler <nbowler@elliptictech.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Warren <swarren@nvidia.com>
Date: Sun, 19 Feb 2012 22:57:15 +0800
In-Reply-To: <20120217155922.0826ca48.akpm@linux-foundation.org>
References: <1328852421-19678-1-git-send-email-amwang@redhat.com>
	 <1328852421-19678-2-git-send-email-amwang@redhat.com>
	 <20120217155922.0826ca48.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 15:59 -0800, Andrew Morton wrote:
> 
> I can't merge these patches because they're already in linux-next.
> 

Confused, we can drop it from linux-next as soon as you take them. :-/

> This is silly.  Please send Linus the pull request for 3.4 and be sure to cc
> myself on it.
> 

Okay.

Thanks.


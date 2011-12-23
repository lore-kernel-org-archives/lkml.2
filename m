Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1LWC4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 21:56:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab1LWC4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 21:56:33 -0500
Date: Thu, 22 Dec 2011 21:56:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223025629.GE12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222175834.66559c8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:58:34PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 20:40:43 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > That's why the need of per cpu data structures to make stat collection
> > lockless.
> 
> btw, (and this is a common refrain): was there any reason for avoiding
> using percpu_counters here?

Frankly speaking I did not consider that. I will look into it (/me needs
to read up a bit on per cpu counter and look at code examples).

Thanks
Vivek

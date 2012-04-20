Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab2DTRRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:17:49 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:44181 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2DTRRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:17:47 -0400
Date: Fri, 20 Apr 2012 10:17:42 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: per-queue policy activation, take#2
Message-ID: <20120420171742.GC32324@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <20120420080943.GG7505@kernel.dk>
 <4F91503D.2060402@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F91503D.2060402@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Fri, Apr 20, 2012 at 02:02:05PM +0200, Jens Axboe wrote:
> Tejun, everything merged in cleanly. A boot test didn't not go so well,
> I'm afraid. It complains about stuck RCU. Even with extra RCU
> debugging/info turned on, it doesn't give my any extra info.
> 
> Config is attached. I can try and debug this on Monday, for now I've
> pulled it out of for-next again.

Hmmm... it works fine with the same config here (qemu w/ 4 cpus
configured).  Doesn't stuck RCU usually come from unbalanced RCU
lock/unlocking?  That should trigger context or RCU warnings before
anything else, weird.  Anyways, it would be great if you can provide
more info on how to reproduce the problem.

Thanks.

-- 
tejun

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2BGAjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 19:39:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52522 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2BGAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 19:39:52 -0500
Date: Mon, 6 Feb 2012 16:39:48 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120207003948.GE21292@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
 <20120206151219.GC30752@redhat.com>
 <4F2FFB21.9000202@kernel.dk>
 <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <20120206203604.GC21292@google.com>
 <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEVzs=pUhQSTvUppkDcc2TNZyfohBRLygW5zFmXyk5A-xQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 07, 2012 at 08:31:22AM +0800, Shaohua Li wrote:
> Since you are talking about performance, one of our microbenchmark (swap)
> shows a regression. Alex bisect it to be b2efa05265d62bc2, which is related to
> the ioc change. A little strange to me, don't expect such change can cause
> performance issue. I haven't double check the issue, but if you have
> ideas, please let me know.

Hmmm... I think the only thing which can be made slower by that patch
is ioc release (ie. task exits).  What does the microbench do?

Thanks.

-- 
tejun

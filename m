Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2AFEkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 23:40:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61555 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2AFEkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 23:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <1325823349.22361.523.camel@sli10-conroe>
References: <20120103200906.GG31746@google.com>
	<4F03631C.8080501@kernel.dk>
	<20120103221301.GH31746@google.com>
	<20120103223505.GI31746@google.com>
	<20120105012445.GP31746@google.com>
	<alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	<20120105183842.GF18486@google.com>
	<20120106021707.GA6276@google.com>
	<20120106023638.GC6276@google.com>
	<1325819655.22361.513.camel@sli10-conroe>
	<20120106030406.GD6276@google.com>
	<1325820878.22361.518.camel@sli10-conroe>
	<CAOS58YOcciTFzYU9vsW2pnE=dbNo+rGz2XJ0Qjk4VHriNDw31g@mail.gmail.com>
	<1325823349.22361.523.camel@sli10-conroe>
Date: Thu, 5 Jan 2012 20:40:06 -0800
X-Google-Sender-Auth: l2Id01ly2jUkCY5MhMCeIqXZKA0
Message-ID: <CAOS58YPNaapUy0PBJjaHe+aSC-46_QJEEzSbJdcWLhxvqJzytA@mail.gmail.com>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump to
 a different cfqq
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 5, 2012 at 8:15 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> don't know. I don't think a tweak for merge impacts isolation so much.
> For rotate disk, request size hasn't impact to request cost, so this
> doesn't impact isolation. Even for ssd, big size request is more
> efficient to dispatch. And we already have breakage of fairness for SSD,
> such as no idle.

I'm not saying they shouldn't be merged but the decision should be
elevator's. Block core shouldn't decide it for the elevator. So,
whether cross cfqq merge is a good idea or not is mostly irrelevant in
this thread.

Thanks.

-- 
tejun

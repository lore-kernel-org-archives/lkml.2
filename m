Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2BFTQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:16:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab2BFTQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:16:01 -0500
Date: Mon, 6 Feb 2012 18:19:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: tj@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to-mm
	tree
Message-ID: <20120206171928.GA9435@redhat.com>
References: <87aa56qedn.fsf@rustcorp.com.au> <20120130002511.GF17211@htj.dyndns.org> <20120130130335.GB11414@redhat.com> <20120130172851.GD3355@google.com> <20120203180030.GA8842@redhat.com> <201202042156.HCJ57836.OQMFSVJHLtFOFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202042156.HCJ57836.OQMFSVJHLtFOFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Tetsuo Handa wrote:
>
> Oleg Nesterov wrote:
> > What do you think about s/khelper/system/ instead of this patch?
>
> I'm not catching up with this topic. But I'm fine with any solution provided
> that it can handle

I think it should...

Tetsuo, all, sorry I am busy today. I'll try to return tomorrow to
continue this (and off-list) discussion.

Oleg.


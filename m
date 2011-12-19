Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1LTAKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 19:10:04 -0500
Received: from ozlabs.org ([203.10.76.45]:55036 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab1LTAKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 19:10:02 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Cc: joe@perches.com, linux-kernel@vger.kernel.org, pawel.moll@arm.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 14/15] module_param: make bool parameters really bool (net & drivers/net)
In-Reply-To: <20111219.162210.1739976094495078504.davem@davemloft.net>
References: <87k45xqvfs.fsf@rustcorp.com.au> <20111215.231517.185391590658983405.davem@davemloft.net> <87ehw1nm9r.fsf@rustcorp.com.au> <20111219.162210.1739976094495078504.davem@davemloft.net>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 20 Dec 2011 10:24:43 +1030
Message-ID: <87liq8m81o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011 16:22:10 -0500 (EST), David Miller <davem@davemloft.net> wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Mon, 19 Dec 2011 16:19:52 +1030
> 
> > On Thu, 15 Dec 2011 23:15:17 -0500 (EST), David Miller <davem@davemloft.net> wrote:
> >> From: Rusty Russell <rusty@rustcorp.com.au>
> >> Date: Fri, 16 Dec 2011 09:44:31 +1030
> >> 
> >> > Dave, did you want a true/false cleanup too?
> >> 
> >> Please, this kind of stuff rots forever and not using bool properly
> >> drives me crazy.
> > 
> > And here's the updated patch:
> 
> Neither of your two patches comes close to applying cleanly to net-next,
> even when I try to apply it by hand there are rejects and references to
> files that don't even exist in net-next any more.

Yeah, no surprise there.  Resending.

Cheers,
Rusty.

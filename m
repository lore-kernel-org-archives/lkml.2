Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab1KBPeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:34:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:58986 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374Ab1KBPel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:34:41 -0400
Date: Wed, 2 Nov 2011 11:34:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <rusty@rustcorp.com.au>,
        <mingo@elte.hu>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] introduce export.h; reduce module.h usage
Message-ID: <20111102153419.GB25190@windriver.com>
References: <20111101004542.GA18671@windriver.com>
 <CA+55aFz7dRWdQy_39+sCMeuqkavg8gYYyH_4u-n66OFVYzAWTg@mail.gmail.com>
 <20111102134403.ac0356474f31c16998ef5103@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111102134403.ac0356474f31c16998ef5103@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [GIT PULL] introduce export.h; reduce module.h usage] On 02/11/2011 (Wed 13:44) Stephen Rothwell wrote:

[...]

> One the other hand, there are some commits near the end that are cleanrly
> just fixing up problems caused by earlier commits.  They could probably
> be included earlier in the series (most of them are trivial).

There should be no commits which fix up errors in my earlier commits.
The two last commits you see at the end of the series may look like that
somewhat, but are in fact fixups of stuff already upstream by others.

Thanks,
Paul.

> 
> Anyway, Paul can speak for himself.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab0J1QjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:39:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55295 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab0J1QjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:39:01 -0400
Date: Thu, 28 Oct 2010 18:38:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: -tip: origin tree build failure (was: [GIT PULL] ext4 update for
 2.6.37)
Message-ID: <20101028163854.GA15450@elte.hu>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop>
 <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 28, 2010 at 12:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Today's -tip fails to build due to upstream commit 5dabfc7 ("ext4: rename 
> > {exit,init}_ext4_*() to ext4_{exit,init}_*()"), on all[yes/mod]config with 
> > CONFIG_EXT4_FS_XATTR disabled:
> 
> Btw, could you try to write these things so that the changelog doesn't have to be 
> totally rewritten? Now I always end up having to move things around and edit them 
> to be useful from a long-term perspective, which is kind of silly.

Heh, i was just lazy and used sfr's linux-next build bug reporting mails as a 
template ;-)

Point taken in any case, i'll read your edited changelog and will change the 
template accordingly.

Would this:

  Upstream commit 5dabfc7 ("ext4: rename {exit,init}_ext4_*() to 
  ext4_{exit,init}_*()"), breaks the build on all[yes/mod]config with
  CONFIG_EXT4_FS_XATTR disabled:

  ...

have been better?

Thanks,

	Ingo

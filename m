Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab2CUWGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:06:46 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36158 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab2CUWGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:06:45 -0400
Date: Wed, 21 Mar 2012 17:06:52 -0500
From: Ben Myers <bpm@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [GIT PULL] XFS update for 3.4-rc1
Message-ID: <20120321220652.GJ8451@sgi.com>
References: <20120321183613.2C93F426DA7@whiskey.americas.sgi.com> <CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyz5UWiJeeMbwZUZEscisZY5Jb0nADpJP6jWKwf3Uai1A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

On Wed, Mar 21, 2012 at 01:59:22PM -0700, Linus Torvalds wrote:
> On Wed, Mar 21, 2012 at 11:36 AM, Ben Myers <bpm@sgi.com> wrote:
> >
> >   Please pull from git://oss.sgi.com/xfs/xfs for-linus
> 
> "Already up-to-date."
> 
> I'd assume you forgot to push, but in fact all the things you quote
> there seem to have been in 3.3 already. So the whole pull request
> seems stale.
> 
> Wazzup?

PEBKAC mostly.

xfs/master contains scalability improvements for dquots, log grant code
cleanups, plus bugfixes and cleanups large and small.

Unfortunately the stuff in:  git://oss.sgi.com/xfs/xfs master

Conflicts with the stuff in:  git://oss.sgi.com/xfs/xfs for-linus

I've resolved the conflict here:  git://oss.sgi.com/xfs/xfs for-linus-merged

I would like to figure out how to 
1) send important bugfixes upstream after rc1, and
2) not hold up development commits to xfs/master, while
3) avoiding conflicts like this.

Our old strategy was to hold off on development commits for awhile after
rc1, and I would like to avoid that.  It occured to me that
fast-forwarding xfs/master immediately to an important bugfix once it
has been pulled in to your tree might accomplish this, but clearly I
didn't get that figured out.

Thanks,
Ben


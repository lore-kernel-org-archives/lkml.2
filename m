Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1CPUVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:21:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36183 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1CPUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:21:25 -0400
Date: Wed, 16 Mar 2011 20:21:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] several fixes
Message-ID: <20110316202117.GW22723@ZenIV.linux.org.uk>
References: <20110316144253.GT22723@ZenIV.linux.org.uk>
 <E1PzuM6-0006iJ-KV@pomaz-ex.szeredi.hu>
 <AANLkTinC2i_+kBjRNFsf8fCKMWJ1zvxAf-A9rf+ZGt-y@mail.gmail.com>
 <E1PzvHb-0006x5-IF@pomaz-ex.szeredi.hu>
 <AANLkTikTRntUNBHnBrOdcCbRfmo=mNiYMDkeV61qhA17@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikTRntUNBHnBrOdcCbRfmo=mNiYMDkeV61qhA17@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 11:49:31AM -0700, Linus Torvalds wrote:
> On Wed, Mar 16, 2011 at 11:17 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >>
> >> "doesn't need" or "must not have"?
> >
> > It must not have one, otherwise refcounting will go astray.
> 
> That's what I thought. The commit message just seemed to be off.
> 
> > That cdev_put() should really be moved into f_op->release(), but that
> > would be quite a bit of work.
> 
> Yeah. Al?

In tree, with edited commit message...  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus
(just one commit in that branch)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1ALPJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:09:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:53221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab1ALPJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:09:29 -0500
Date: Wed, 12 Jan 2011 16:09:27 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] UDF tree
Message-ID: <20110112150927.GA4185@quack.suse.cz>
References: <20110111205233.GC4501@quack.suse.cz>
 <AANLkTikB4XJRQ-NVW3BJpVSyTJi57DuAvog9frefGfGX@mail.gmail.com>
 <AANLkTimsTvMi3t2c5CfCBY32rnF5NxwMwYGOYw7J77AX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimsTvMi3t2c5CfCBY32rnF5NxwMwYGOYw7J77AX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-01-11 14:44:23, Linus Torvalds wrote:
> On Tue, Jan 11, 2011 at 2:39 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Hmm.. The Kconfig file still claims it depends on BKL, so you cannot
> > actually build it without that.
> >
> > Oversight? Or is it not complete?
> 
> Seems to be an oversight, because it compiles without the BKL.
> 
> I'll remove that thing in the merge commit, evil as I am.
  Thanks. It was an oversight.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

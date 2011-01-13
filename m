Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064Ab1AMQLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:11:02 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41230 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab1AMQLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:11:00 -0500
MIME-Version: 1.0
Message-ID: <64afb13a-0ff8-4c98-9d52-06bef54bd4eb@default>
Date: Thu, 13 Jan 2011 08:08:46 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: RE: clearcache (Was: Re: [git pull] vfs pile 1)
References: <20110113053554.GQ19804@ZenIV.linux.org.uk>
 <20110113172557.c016ec51.sfr@canb.auug.org.au>
 <20110113085547.GA7414@infradead.org
 20110113214239.1b23b523.sfr@canb.auug.org.au>
In-Reply-To: <20110113214239.1b23b523.sfr@canb.auug.org.au>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6539.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 13 Jan 2011 03:55:47 -0500 Christoph Hellwig
> <hch@infradead.org> wrote:
> >
> > How did cleancache end up in linux-next again?
> 
> Um, I asked after the last merge window (on November 17, cc'ing you, Al
> and Linus) and the only reply I got was from Dan saying that he was
> hoping to work more on it with some chance of being ready for 2.6.38
> ...
> 
> So, let me ask again:
> 
> "I didn't really follow the discussion at Kernel Summit, but there
> seemed
> to be some question as to whether the cleancache stuff will be merged
> or
> not.  It missed 2.6.37 (obviously), but my question now is do I keep in
> in linux-next in the hope that it will be merged in 2.6.38?  Or is that
> not going to happen?"
> 
> (The cleancache tree has not changed since October 9 last year.)

Hi Stephen --

Today or tomorrow, I will post a fully-functional in-kernel non-virtualization
user for cleancache (and frontswap), called kztmem, which is proposed
initially as a staging driver.  It will be up to Linus, Andrew, and
GregKH to determine if this is acceptable and a sufficient second user
of cleancache.  Assuming it is, because of the dependency (staging driver
dependent on as-yet-unmerged core kernel functionality), I'm not clear
yet if/how cleancache should go through linux-next.  (Linus's last
email on the topic indicated he thought cleancache should go through Andrew.)

So please stay tuned for the next episode in this continuing drama. ;-)

Thanks,
Dan


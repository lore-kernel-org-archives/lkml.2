Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab2AXQhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:37:01 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49005
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465Ab2AXQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:37:00 -0500
Date: Tue, 24 Jan 2012 11:36:56 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PULL REQUEST] Ext3 & ext2 fix, quota improvement
Message-ID: <20120124163656.GA25717@infradead.org>
References: <20120120163910.GA16973@quack.suse.cz>
 <20120124142500.GE18136@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124142500.GE18136@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 03:25:00PM +0100, Jan Kara wrote:
> > Jan Kara (2):
> >       jbd: Issue cache flush after checkpointing
> >       quota: Pass information that quota is stored in system file to userspace
>   Did you just forget to pull or do you disagree with some of the changes?

FYI, I'll take my complaint back.  While waiting multiple month between
review and pull isn't nice it's probably fine by the protocol, and the
actual change looks fine.


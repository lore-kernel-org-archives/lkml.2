Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab2JMPsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 11:48:18 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58170
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab2JMPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 11:48:15 -0400
Date: Sat, 13 Oct 2012 11:48:10 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
Message-ID: <20121013154810.GA9678@infradead.org>
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
 <5079164D.4030307@gmail.com>
 <20121013075128.GQ2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121013075128.GQ2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 08:51:28AM +0100, Al Viro wrote:
> It's somewhat pointless on its own...  If you were doing something with
> the callers afterwards - sure, it would be make sense, but as it is...

I'd really like to see ->truncate and vmtruncate done, so from that side
I'm absolutely in favour of this series.  What I'm a bit concerned about
is that it just does the trivial 1:1 conversion and not actually
converts the sequence of operations to the proper form, which was one
of the two big reasons of moving away from ->truncate to start with.

I'd love to see the full conversion, but without adequate test coverage
for all the fringe filesystems that might be a bit too much to expect
from Marco.

I think just doing the easy conversions he did, and putting a TODO
comment explaining how it should be taken further at each of the sites
would be valueable on its own.


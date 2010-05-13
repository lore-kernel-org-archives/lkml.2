Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab0EMPx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:53:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:51197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363Ab0EMPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:53:57 -0400
Subject: Re: [PATCH] vfs: Fix O_NOFOLLOW behavior for paths with trailing
 slashes
From: James Bottomley <James.Bottomley@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20100513154710.GA19228@infradead.org>
References: <1273747977-4579-1-git-send-email-jack@suse.cz>
	 <alpine.LFD.2.00.1005130823370.3711@i5.linux-foundation.org>
	 <20100513154135.GB21251@quack.suse.cz>
	 <20100513084335.7267bcf5.akpm@linux-foundation.org>
	 <20100513154710.GA19228@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 10:53:51 -0500
Message-ID: <1273766031.4353.181.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 11:47 -0400, Christoph Hellwig wrote:
> On Thu, May 13, 2010 at 08:43:35AM -0400, Andrew Morton wrote:
> > Yes, it's a bit tricky (for me, at least) to work out "which kernel version did
> > that patch go into" via git.
> 
> git-describe <revid>

Actually, that will print the version it was applied to.  To find out
the version it was pulled into, you need git-describe --contains <revid>

James



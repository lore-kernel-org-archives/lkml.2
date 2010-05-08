Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0EHMwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 08:52:23 -0400
Received: from thunk.org ([69.25.196.29]:46205 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab0EHMwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 08:52:22 -0400
Date: Sat, 8 May 2010 08:52:15 -0400
From: tytso@mit.edu
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unified page and buffer cache?
Message-ID: <20100508125215.GH18762@thunk.org>
Mail-Followup-To: tytso@mit.edu, Phillip Susi <psusi@cfl.rr.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <4BCC7C05.8000803@cfl.rr.com>
 <4BE417CB.7000806@cfl.rr.com>
 <20100507135329.GA17259@parisc-linux.org>
 <4BE4359E.9020400@cfl.rr.com>
 <20100508004617.GF18762@thunk.org>
 <1273280081.2444.5.camel@faldara>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273280081.2444.5.camel@faldara>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 08:54:41PM -0400, Phillip Susi wrote:
> Would it be possible to somehow keep the current buffer heads, but
> associate them with the inode such that readahead() on the directory
> would work?

Maybe.   Try it and send patches.  :-)

As I said, it's not high on my priority list and I'm *way* behind on
all sorts of other, much higher priority tasks.  If you were going to
do the patches (which would have all sorts of complications since
you'd have to make sure directory pages didn't get written back via
the page write cache or via direct reclaim), I wouldn't reject them
out of hand since there are a few other advantages of doing things
that way....  

*However*, I suspect it would be easier for you to simply use the
FIEMAP ioctl had deal with directories separately from files.....

							- Ted

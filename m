Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0IEHpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:45:40 -0400
Received: from 1wt.eu ([62.212.114.60]:43538 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0IEHpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:45:39 -0400
Date: Sun, 5 Sep 2010 09:44:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: XFS status update for August 2010
Message-ID: <20100905074457.GC16004@1wt.eu>
References: <20100902145959.GA27887@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902145959.GA27887@infradead.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Sep 02, 2010 at 10:59:59AM -0400, Christoph Hellwig wrote:
> At the first of August we finally saw the release of Linux 2.6.35,
> which includes a large XFS update.  The most prominent feature in
> Linux 2.6.35 is the new delayed logging code which provides massive
> speedups for metadata-intensive workloads, but there has been
> a large amount of other fixes and cleanups, leading to the following
> diffstat:
> 
> 	 67 files changed, 4426 insertions(+), 3835 deletions(-)
> 
> Given the early release of Linux 2.6.35 the merge window for the
> next release fully fell into the month of August.  The XFS updates
> for Linux 2.6.36 include various additional performance improvements
> in the delayed logging code, for direct I/O writes and for avoiding
> synchronous transactions, as well as various fixed and large amount
> of cleanups, including the removal of the remaining dead DMAPI
> code.

This is very good news. I have XFS on my laptop and I regret I have
installed it there, because working on the kernel is very painful with
it. A "cp -al $old_dir $new_dir" takes about 1 minute while it takes
approximatively one second on reiserfs. I've just installed 2.6.35.4
and did not notice any improvement. However, I'm clearly interested
in testing any possible pending code that you think should improve
this behaviour by delaying log writes.

So if you have any pointer to recommended patches or a git tree (based
on an kernel reliable enough for a laptop used for work), I'd be
interested in trying them.

Regards,
Willy


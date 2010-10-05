Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab0JEQkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:40:22 -0400
Received: from thunk.org ([69.25.196.29]:39876 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab0JEQkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:40:20 -0400
Date: Tue, 5 Oct 2010 11:59:50 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug #19062] Dirtiable inode bdi default != sb bdi btrfs
Message-ID: <20101005155949.GA18454@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>,
	Cesar Eduardo Barros <cesarb@cesarb.net>, Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Jan Kara <jack@suse.cz>
References: <MEG5YPP-fxC.A.vnD.So6nMB@chimera>
 <sQALkqF1FWE.A.15D.bo6nMB@chimera>
 <20101002165433.GL21129@thunk.org>
 <201010022358.35972.rjw@sisk.pl>
 <20101004130911.1375c6e3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004130911.1375c6e3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 01:09:11PM -0700, Andrew Morton wrote:
> 
> Christoph had a patch, and Jan had another patch.  Maybe
> 
> commit 692ebd17c2905313fff3c504c249c6a0faad16ec
> Author: Jan Kara <jack@suse.cz>
> Date:   Tue Sep 21 11:51:01 2010 +0200
> 
>     bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends
> 
> already fixed this?
> 

Actually, I do believe that's the _cause_ of what I was seeing.  The
fix is:

	  http://lkml.org/lkml/2010/9/29/76

						- Ted


				

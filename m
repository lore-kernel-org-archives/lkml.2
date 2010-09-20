Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab0ITVav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:30:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59791 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757716Ab0ITVaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:30:46 -0400
Date: Mon, 20 Sep 2010 23:29:56 +0200
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Jan Kara <jack@suse.cz>,
        Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: [Bug #16312] WARNING: at fs/fs-writeback.c:1127
 __mark_inode_dirty
Message-ID: <20100920212955.GB14020@quack.suse.cz>
References: <r2gGqgg1zFC.A.LrE.w97lMB@chimera>
 <aRnAGz9xZ8K.A.wgG.uA8lMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRnAGz9xZ8K.A.wgG.uA8lMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-09-10 21:57:17, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).
  The patch is in block tree, going to 2.6.37 and then -stable trees.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2010-06-28 9:40 (85 days old)
> Message-ID	: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2
> 		  http://lkml.indiana.edu/hypermail/linux/kernel/1007.3/00884.html
> Handled-By	: Jan Kara <jack@suse.cz>
> 		  Jan Kara <jack@suse.cz>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=30282

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

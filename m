Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2IKAbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 20:31:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:11004 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab2IKAbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 20:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,400,1344236400"; 
   d="scan'208";a="220490391"
Date: Tue, 11 Sep 2012 08:31:11 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Wang Sheng-Hui <shhuiw@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: correct comment for
 fs/fs-writeback.c/move_expired_inodes
Message-ID: <20120911003111.GA21134@localhost>
References: <504B68EC.50807@gmail.com>
 <20120910162633.GA29178@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910162633.GA29178@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 06:26:33PM +0200, Jan Kara wrote:
> On Sat 08-09-12 23:49:00, Wang Sheng-Hui wrote:
> > The function scans @delaying_queue and stops at the first inode
> > whose dirtied_when is after *work->older_than_this. So the expired
> > ones being moved are those before *work->older_than_this. Correct
> > the comment here.
>   Fengguang Wu would be a more appropriate for this. Added to CC. BTW the
> patch is fine so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Applied. Thank you!

Fengguang

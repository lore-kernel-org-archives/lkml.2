Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2EGC5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:57:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:36535 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab2EGC5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:57:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="149958950"
Date: Mon, 7 May 2012 10:57:05 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com
Subject: Re: [PATCH 0/7 v3] writeback: Avoid iput() from flusher thread
Message-ID: <20120507025705.GA27492@localhost>
References: <1336049283-5859-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336049283-5859-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 02:47:54PM +0200, Jan Kara wrote:
>   Hi,
> 
>   this is a third iteration of my patch series for getting rid of iput() from
> flusher thread. I think all the comments should be addressed. So please have
> a look.

It runs fine here. I just pushed it to linux-next for more testing. Thank you!

Thanks,
Fengguang

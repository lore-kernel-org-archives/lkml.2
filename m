Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0IMCuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:50:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:34564 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0IMCuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:50:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,357,1280732400"; 
   d="scan'208";a="553867990"
Date: Mon, 13 Sep 2010 10:50:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 2/5] mm: account_page_writeback added
Message-ID: <20100913025010.GA7697@localhost>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
 <1284323440-23205-3-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284323440-23205-3-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 04:30:37AM +0800, Michael Rubin wrote:
> This allows code outside of the mm core to safely manipulate page
> writeback state and not worry about the other accounting. Not using
> these routines means that some code will lose track of the accounting
> and we get bugs.
> 
> Modified nilfs2 to use interface.
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

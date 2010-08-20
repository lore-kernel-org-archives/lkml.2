Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab0HTJpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:45:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:57912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab0HTJpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:45:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,238,1280732400"; 
   d="scan'208";a="547111251"
Date: Fri, 20 Aug 2010 17:45:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Michael Rubin <mrubin@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] mm: account_page_writeback added
Message-ID: <20100820094525.GB8440@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-3-git-send-email-mrubin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282296689-25618-3-git-send-email-mrubin@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure this should be an inline function, just a reminder.
Even with one more inc_zone_page_state() in next patch.

> +void account_page_writeback(struct page *page)
> +{
> +	inc_zone_page_state(page, NR_WRITEBACK);
> +}
> +EXPORT_SYMBOL(account_page_writeback);


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1DZFzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 01:55:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:7882 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1DZFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 01:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,267,1301900400"; 
   d="scan'208";a="425473974"
Date: Tue, 26 Apr 2011 13:55:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: readahead and oom
Message-ID: <20110426055521.GA18473@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 01:49:25PM +0800, Dave Young wrote:
> Hi,
> 
> When memory pressure is high, readahead could cause oom killing.
> IMHO we should stop readaheading under such circumstances。If it's true
> how to fix it?

Good question. Before OOM there will be readahead thrashings, which
can be addressed by this patch:

http://lkml.org/lkml/2010/2/2/229

However there seems no much interest on that feature.. I can separate
that out and resubmit it standalone if necessary.

Thanks,
Fengguang

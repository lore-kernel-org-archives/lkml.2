Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1KUMrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:47:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42171 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KUMrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:47:18 -0500
Date: Mon, 21 Nov 2011 13:47:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jens Axboe <jens.axboe@oracle.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] block: limit default readahead size for small devices
Message-ID: <20111121124715.GD24062@one.firstfloor.org>
References: <20111121091819.394895091@intel.com> <20111121093846.121502745@intel.com> <20111121100004.GB5084@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121100004.GB5084@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:00:04AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 21, 2011 at 05:18:20PM +0800, Wu Fengguang wrote:
> > Given that the non-rotational attribute is not always reported, we can
> > take disk size as a max readahead size hint. This patch uses a formula
> > that generates the following concrete limits:
> 
> Given that you mentioned the rotational flag and device size in this
> mail, as well as benchmarking with an intel SSD  -  did you measure
> how useful large read ahead sizes still are with highend Flash device
> that have extremly high read IOP rates?

The more the IOPs the larger the "window" you need to keep everything
going I suspect.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

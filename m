Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab1KULYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 06:24:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:17088 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab1KULYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 06:24:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,546,1315206000"; 
   d="scan'208";a="77507558"
Date: Mon, 21 Nov 2011 19:24:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jens Axboe <jens.axboe@oracle.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/8] block: limit default readahead size for small
 devices
Message-ID: <20111121112409.GA8895@localhost>
References: <20111121091819.394895091@intel.com>
 <20111121093846.121502745@intel.com>
 <20111121100004.GB5084@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121100004.GB5084@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 06:00:04PM +0800, Christoph Hellwig wrote:
> On Mon, Nov 21, 2011 at 05:18:20PM +0800, Wu Fengguang wrote:
> > This looks reasonable: smaller device tend to be slower (USB sticks as
> > well as micro/mobile/old hard disks).
> > 
> > Given that the non-rotational attribute is not always reported, we can
> > take disk size as a max readahead size hint. This patch uses a formula
> > that generates the following concrete limits:
> 
> Given that you mentioned the rotational flag and device size in this
> mail, as well as benchmarking with an intel SSD  -  did you measure
> how useful large read ahead sizes still are with highend Flash device
> that have extremly high read IOP rates?

I don't know -- I don't have access to such highend devices.

However the patch changelog has the simple test script. It would be
high appreciated if someone can help collect the data :)

Thanks,
Fengguang

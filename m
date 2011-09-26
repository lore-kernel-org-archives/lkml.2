Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1IZHeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:34:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:47536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771Ab1IZHeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:34:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,442,1312182000"; 
   d="scan'208";a="67442422"
Subject: Re: [patch]mm: add more blk plug
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110926073025.GB21079@infradead.org>
References: <1317004226.29510.172.camel@sli10-conroe>
	 <20110926073025.GB21079@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 15:38:47 +0800
Message-ID: <1317022727.29510.175.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 15:30 +0800, Christoph Hellwig wrote:
> On Mon, Sep 26, 2011 at 10:30:26AM +0800, Shaohua Li wrote:
> > Some filesystems implement .writepages. We don't have blk plug
> > in such filesystems for .writepages.
> 
> Please add the plugging in the actual ->writepages instances.
there are several filesystems have ->writepages. Can you share an hint
why we don't add plugging in the do_writepages?

Thanks,
Shaohua


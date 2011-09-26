Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1IZHah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:30:37 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42507
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755Ab1IZHad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:30:33 -0400
Date: Mon, 26 Sep 2011 03:30:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch]mm: add more blk plug
Message-ID: <20110926073025.GB21079@infradead.org>
References: <1317004226.29510.172.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317004226.29510.172.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:30:26AM +0800, Shaohua Li wrote:
> Some filesystems implement .writepages. We don't have blk plug
> in such filesystems for .writepages.

Please add the plugging in the actual ->writepages instances.


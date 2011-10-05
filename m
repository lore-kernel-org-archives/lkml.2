Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1JEUbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 16:31:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906Ab1JEUbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 16:31:34 -0400
Date: Wed, 5 Oct 2011 16:31:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] RFC: ->make_request support for virtio-blk
Message-ID: <20111005203116.GM30146@redhat.com>
References: <20111005195403.407628164@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005195403.407628164@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:54:03PM -0400, Christoph Hellwig wrote:
> This patchset allows the virtio-blk driver to support much higher IOP
> rates which can be driven out of modern PCI-e flash devices.  At this
> point it really is just a RFC due to various issues.
> 

So you no longer believe that request queue overhead can be brought
down to mangeable levels for these fast devices. And instead go for
bio based drivers and give up on merging and implement own FLUSH/FUA
machinery.

Not that I am advocating for continuing with request based driver. Just
curious..

Thanks
Vivek

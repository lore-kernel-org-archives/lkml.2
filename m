Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429Ab1JEVxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:53:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:56191
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934884Ab1JEVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:53:40 -0400
Date: Wed, 5 Oct 2011 17:53:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] RFC: ->make_request support for virtio-blk
Message-ID: <20111005215330.GA13514@infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005203116.GM30146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005203116.GM30146@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 04:31:16PM -0400, Vivek Goyal wrote:
> So you no longer believe that request queue overhead can be brought
> down to mangeable levels for these fast devices. And instead go for
> bio based drivers and give up on merging and implement own FLUSH/FUA
> machinery.

Not in a reasonable time frame. Having a common interface is still the
grand plan, but the virtio performance issues are hurting people so
badly that we need a fix soon.


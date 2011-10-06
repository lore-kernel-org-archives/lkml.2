Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935701Ab1JFImZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 04:42:25 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:36690 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 04:42:23 -0400
Date: Thu, 6 Oct 2011 09:42:18 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
Message-ID: <20111006084218.GA16511@stefanha-thinkpad.localdomain>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195529.964397366@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005195529.964397366@bombadil.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 03:54:05PM -0400, Christoph Hellwig wrote:
> Split virtqueue_kick to be able to do the actual notification outside the
> lock protecting the virtqueue.  This patch was originally done by
> Stefan Hajnoczi, but I can't find the original one anymore and had to
> recreated it from memory.  Pointers to the original or corrections for
> the commit message are welcome.

Here is the patch:
https://github.com/stefanha/linux/commit/a6d06644e3a58e57a774e77d7dc34c4a5a2e7496

Or as an email if you want to track it down in your inbox:
http://www.spinics.net/lists/linux-virtualization/msg14616.html

The code you posted is equivalent, the only additional thing my patch
did was to update doc comments in include/linux/virtio.h.  Feel free to
grab my patch or just the hunk.

Stefan

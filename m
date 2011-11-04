Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1KDKgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 06:36:50 -0400
Received: from ozlabs.org ([203.10.76.45]:32825 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1KDKgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 06:36:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Cc: mst@redhat.com, Christoph Hellwig <hch@infradead.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3 of 5] virtio: support unlocked queue kick
In-Reply-To: <20111103075211.GD6993@infradead.org>
References: <patchbomb.1320306168@localhost6.localdomain6> <c0db93dbb414ab6dbcde.1320306171@localhost6.localdomain6> <20111103075211.GD6993@infradead.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 04 Nov 2011 21:06:09 +1030
Message-ID: <87k47grx7q.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 03:52:11 -0400, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Nov 03, 2011 at 06:12:51PM +1030, Rusty Russell wrote:
> > Based on patch by Christoph for virtio_blk speedup:
> 
> Please credit it to Stefan - he also sent a pointer to his original
> version in reply to the previous thread.
> 
> Also shouldn't virtqueue_kick have kerneldoc comments?

Yep, and I've credited it properly.

> I also notices that you documented the functions bother here and in
> the first patch in the headers.  At least historically the kerneldoc
> tools didn't parse comments at declarations, but only at the function
> defintions.  Did you check these actually get picked up?

Gah, I'd forgotten that the kernel tendency is to put the interface
documentation next to the implementation.

Personally, I think extracting it is insane, but I've moved them.

Thanks,
Rusty.

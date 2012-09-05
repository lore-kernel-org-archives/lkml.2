Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614Ab2IFDCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:02:03 -0400
Received: from ozlabs.org ([203.10.76.45]:38909 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab2IFDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 1/5] virtio-ring: move queue_index to vring_virtqueue
In-Reply-To: <1346154857-12487-2-git-send-email-pbonzini@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-2-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 09:02:24 +0930
Message-ID: <877gs8jbav.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> From: Jason Wang <jasowang@redhat.com>
>
> Instead of storing the queue index in transport-specific virtio structs,
> this patch moves them to vring_virtqueue and introduces an helper to get
> the value.  This lets drivers simplify their management and tracing of
> virtqueues.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Sorry for the delay, I was at Kernel Summit and am only now actually
reading (vs skimming) my backlog.

Putting it in vring_virtqueue rather than virtqueue seems weird, though.
But I've applied as-is, we can clean up that later if we want (probably
by merging the two structures, I'll have to think harder on that).

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

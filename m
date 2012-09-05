Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379Ab2IFDBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:01:14 -0400
Received: from ozlabs.org ([203.10.76.45]:34732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab2IFDA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/5] virtio: introduce an API to set affinity for a virtqueue
In-Reply-To: <1346154857-12487-3-git-send-email-pbonzini@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com> <1346154857-12487-3-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 09:02:04 +0930
Message-ID: <878vcojbbf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> From: Jason Wang <jasowang@redhat.com>
>
> Sometimes, virtio device need to configure irq affinity hint to maximize the
> performance. Instead of just exposing the irq of a virtqueue, this patch
> introduce an API to set the affinity for a virtqueue.
>
> The api is best-effort, the affinity hint may not be set as expected due to
> platform support, irq sharing or irq type. Currently, only pci method were
> implemented and we set the affinity according to:
>
> - if device uses INTX, we just ignore the request
> - if device has per vq vector, we force the affinity hint
> - if the virtqueues share MSI, make the affinity OR over all affinities
>   requested
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Applied, thanks.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

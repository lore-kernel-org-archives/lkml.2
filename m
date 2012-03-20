Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab2CTUjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:39:52 -0400
Received: from ozlabs.org ([203.10.76.45]:42458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab2CTUjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:39:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        mst@redhat.com, Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] virtio-spec: clarify ro/rw bits and updating rule of virtio-net status field
In-Reply-To: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400>
References: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 20 Mar 2012 21:35:18 +1030
Message-ID: <87ty1jpm6p.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012 14:20:21 +0800, Jason Wang <jasowang@redhat.com> wrote:
> This patch clarifies VIRTIO_NET_S_LINK_UP as a read-only bit and
> VIRTIO_NET_S_ANNOUNCE as a read-writable bit. Also introduce the write 1 to
> clear semantics for all read-writable bits of config status field. This could
> help to reduce the config status field updating race between host and guest and
> also simplify the implementation.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

This approach assumes an active config field, which neither lguest nor
S/390 have.

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org

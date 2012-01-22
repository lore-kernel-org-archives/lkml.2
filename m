Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2AVX6f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 18:58:35 -0500
Received: from ozlabs.org ([203.10.76.45]:44651 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab2AVX6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 18:58:31 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] virtio: fix typos of memory barriers
In-Reply-To: <20120122114746.GC27222@redhat.com>
References: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com> <20120122114746.GC27222@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 23 Jan 2012 09:37:08 +1030
Message-ID: <871uqrgwv7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jan 2012 13:47:46 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Jan 20, 2012 at 04:16:59PM +0800, Jason Wang wrote:
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Good catch.
> Note: this fixes a bug introduced by
> 7b21e34fd1c272e3a8c3846168f2f6287a4cd72b.
> It's probably a good idea to mention
> this is the commit log.
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Thanks, applied!

Cheers,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030274Ab2CTXmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:42:10 -0400
Received: from ozlabs.org ([203.10.76.45]:56581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab2CTXmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:42:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] virtio-spec: clarify ro/rw bits and updating rule of virtio-net status field
In-Reply-To: <20120320224805.GA4997@redhat.com>
References: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400> <87ty1jpm6p.fsf@rustcorp.com.au> <20120320224805.GA4997@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 21 Mar 2012 10:10:52 +1030
Message-ID: <87ty1ializ.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 00:48:05 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, Mar 20, 2012 at 09:35:18PM +1030, Rusty Russell wrote:
> > On Tue, 20 Mar 2012 14:20:21 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > > This patch clarifies VIRTIO_NET_S_LINK_UP as a read-only bit and
> > > VIRTIO_NET_S_ANNOUNCE as a read-writable bit. Also introduce the write 1 to
> > > clear semantics for all read-writable bits of config status field. This could
> > > help to reduce the config status field updating race between host and guest and
> > > also simplify the implementation.
> > > 
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > This approach assumes an active config field, which neither lguest nor
> > S/390 have.
> > 
> > Thanks,
> > Rusty.
> 
> What does 'active' mean in this context?

It means you are assuming that writes to the config field trap to the
host.

Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org

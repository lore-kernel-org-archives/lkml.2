Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab1LGXgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:36:15 -0500
Received: from ozlabs.org ([203.10.76.45]:58623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab1LGXgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:36:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] virtio: s4 support
In-Reply-To: <20111207074456.GD4651@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com> <87wra8j13m.fsf@rustcorp.com.au> <20111207074456.GD4651@amit-x200.redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Dec 2011 21:22:41 +1030
Message-ID: <87liqoirgm.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011 13:14:56 +0530, Amit Shah <amit.shah@redhat.com> wrote:
> On (Wed) 07 Dec 2011 [17:54:29], Rusty Russell wrote:
> > I figure there's a reason, but it seems a bit weird :)
> 
> Well, there is one reason right now: migrating storage along with
> VMs.  The guest needs to sync all data to the disk before the target
> host accesses the image file.

I don't see why.  Sure, if qemu (or whatever) is doing buffering, it
needs to flush that.  It doesn't, last I looked, it just maps to
read/write.

What am I missing?

Thanks,
Rusty.

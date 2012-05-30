Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2EaGtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 02:49:25 -0400
Received: from ozlabs.org ([203.10.76.45]:32957 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2EaGtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 02:49:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-net: remove useless disable on freeze
In-Reply-To: <20120528125325.GA22576@redhat.com>
References: <20120404091954.GA3776@redhat.com> <20120528125325.GA22576@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 30 May 2012 19:41:47 +0930
Message-ID: <87r4u2dllo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 15:53:25 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Apr 04, 2012 at 12:19:54PM +0300, Michael S. Tsirkin wrote:
> > disable_cb is just an optimization: it
> > can not guarantee that there are no callbacks.
> > 
> > I didn't yet figure out whether a callback
> > in freeze will trigger a bug, but disable_cb
> > won't address it in any case. So let's remove
> > the useless calls as a first step.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Looks like this isn't in the 3.5 pull request -
> just lost in the shuffle?
> disable_cb is advisory so can't be relied upon.

I always (try to?) reply as I accept patches.

This one did slip by, but it's harmless so no need to push AFAICT.

Applied.

Thanks!
Rusty.

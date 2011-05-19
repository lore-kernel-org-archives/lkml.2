Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237Ab1ETEvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:51:32 -0400
Received: from ozlabs.org ([203.10.76.45]:47686 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159Ab1ETEva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:51:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, habanero@linux.vnet.ibm.com,
        Shirley Ma <mashirle@us.ibm.com>, Krishna Kumar2 <krkumar2@in.ibm.com>,
        kvm@vger.kernel.org, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, borntraeger@de.ibm.com,
        avi@redhat.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] virtio_net: fix patch: virtio_net: limit xmit polling
In-Reply-To: <20110518220125.GA26835@redhat.com>
References: <20110518220125.GA26835@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 19 May 2011 17:00:17 +0930
Message-ID: <8739kb5era.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 01:01:25 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> The patch  virtio_net: limit xmit polling
> got the logic reversed: it polled while we had
> capacity not while ring was empty.
> 
> Fix it up and clean up a bit by using a for loop.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> OK, turns out that patch was borken. Here's
> a fix that survived stress test on my box.
> Pushed on my branch, I'll send a rebased series
> with Rusty's comments addressed ASAP.

Normally you would have missed the merge window by now, but I'd really
like this stuff in, so I'm holding it open for this.  I want these patches
in linux-next for at least a few days before I push them.

If you think we're not close enough, please tell me and I'll push
the rest of the virtio patches to Linus now.  

Thanks,
Rusty.

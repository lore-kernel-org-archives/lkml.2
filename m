Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663Ab1JFBRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 21:17:01 -0400
Received: from ozlabs.org ([203.10.76.45]:39732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935627Ab1JFBRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 21:17:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Krishna Kumar <krkumar2@in.ibm.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC] [PATCH] virtio: Dont add "config" to list for !per_vq_vector
In-Reply-To: <20111005104822.GC5587@redhat.com>
References: <20111005053859.5825.1089.sendpatchset@krkumar2.in.ibm.com> <20111005104822.GC5587@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 06 Oct 2011 11:01:00 +1030
Message-ID: <87wrcjezaz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011 08:48:23 -0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Wed, Oct 05, 2011 at 11:08:59AM +0530, Krishna Kumar wrote:
> > For the MSI but non-per_vq_vector case, the config/change vq
> > also gets added to the list of vqs that need to process the
> > MSI interrupt. This is not needed as config has it's own
> > handler (vp_config_changed). In any case, vring_interrupt()
> > finds nothing needs to be done on this vq.
> > 
> > I tested this patch by testing the "Fallback:" and "Finally
> > fall back" cases in vp_find_vqs(). Please review.
> > 
> > Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> (note: this is not a bugfix so not 3.1 material).

Thanks, applied.

Cheers,
Rusty.

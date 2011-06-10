Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1FJLkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:40:21 -0400
Received: from ozlabs.org ([203.10.76.45]:34117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab1FJLkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:40:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
In-Reply-To: <4DF06F4F.8050308@redhat.com>
References: <4DEE2B15.4090809@redhat.com> <87lixbgax9.fsf@rustcorp.com.au> <4DF06F4F.8050308@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Fri, 10 Jun 2011 21:03:59 +0930
Message-ID: <87lix9dioo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jun 2011 08:59:27 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 06/09/2011 01:28 AM, Rusty Russell wrote:
> >> >  after some preliminary discussion on the QEMU mailing list, I present a
> >> >  draft specification for a virtio-based SCSI host (controller, HBA, you
> >> >  name it).
> >
> > OK, I'm impressed.  This is very well written and it doesn't make any of
> > the obvious mistakes wrt. virtio.
> 
> Thanks very much, and thanks to those who corrected my early mistakes.
> 
> > I assume you have an implementation, as well?
> 
> Unfortunately not; "we're working on it", which means I should start in 
> July when I come back from vacation.
> 
> Do you prefer to wait for one before I make a patch to the LyX source? 
> In the meanwhile, can you reserve a subsystem ID for me?
> 
> Paolo

Sure, you can have the next subsystem ID.

It's a pain to patch once it's in LyX, so let's get the implementation
base on what you posted here an see how much it changes first...

Cheers,
Rusty.

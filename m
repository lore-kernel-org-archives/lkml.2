Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab1FHX3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:29:14 -0400
Received: from ozlabs.org ([203.10.76.45]:52540 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab1FHX3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:29:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Christoph Hellwig <chellwig@redhat.com>,
        Hannes Reinecke <hare@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: virtio scsi host draft specification, v3
In-Reply-To: <4DEE2B15.4090809@redhat.com>
References: <4DEE2B15.4090809@redhat.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 09 Jun 2011 08:58:50 +0930
Message-ID: <87lixbgax9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Jun 2011 15:43:49 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Hi all,
> 
> after some preliminary discussion on the QEMU mailing list, I present a
> draft specification for a virtio-based SCSI host (controller, HBA, you
> name it).

OK, I'm impressed.  This is very well written and I doesn't make any of
the obvious mistakes wrt. virtio.

Unfortunately, I know almost nothing of SCSI, so I have to leave it to
others to decide if this is actually useful and sufficient.

I assume you have an implementation, as well?

Thanks,
Rusty.

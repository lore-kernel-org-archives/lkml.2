Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab1LEUS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:18:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147Ab1LEUS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:18:57 -0500
Date: Mon, 5 Dec 2011 22:20:19 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCHv2 RFC] virtio-pci: flexible configuration layout
Message-ID: <20111205202019.GB18939@redhat.com>
References: <20111114181854.GA24953@redhat.com>
 <20111205111605.73b60faa@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205111605.73b60faa@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:16:05AM -0800, Jesse Barnes wrote:
> On Mon, 14 Nov 2011 20:18:55 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > Add a flexible mechanism to specify virtio configuration layout, using
> > pci vendor-specific capability.  A separate capability is used for each
> > of common, device specific and data-path accesses.
> > 
> > Warning: compiled only.
> > This patch also needs to be split up, pci_iomap changes
> > also need arch updates for non-x86.
> > There might also be more spec changes.
> > 
> > Posting here for early feedback, and to allow Sasha to
> > proceed with his "kvm tool" work.
> > 
> > Changes from v1:
> > Updated to match v3 of the spec, see:
> > 	Subject: [PATCHv3 RFC] virtio-spec: flexible configuration layout
> > 	Message-ID: <20111110122436.GA13144@redhat.com>
> > 	In-Reply-To: <20111109195901.GA28155@redhat.com>
> 
> Looks like this conflicts with your other iomap changes... I didn't
> check your latest tree; do you just add another patch on top for the
> virtio changes now?
> 
> Thanks,

Yes. Rusty asked for more changes so that isn't yet pushed.

> -- 
> Jesse Barnes, Intel Open Source Technology Center



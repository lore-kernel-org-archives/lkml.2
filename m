Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2JIOCM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:02:12 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36877 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2JIOCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:02:10 -0400
Date: Tue, 9 Oct 2012 16:02:01 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
        Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        Avishay Traeger <AVISHAY@il.ibm.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, Sasha Levin <levinsasha928@gmail.com>,
        <virtualization@lists.linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        "qemu-devel" <qemu-devel@nongnu.org>
Subject: Re: Proposal for virtio standardization.
Message-ID: <20121009160201.5303a7ca@BR9GNB5Z>
In-Reply-To: <87zk4c2tqq.fsf@rustcorp.com.au>
References: <87zk4c2tqq.fsf@rustcorp.com.au>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12100914-4966-0000-0000-000003B7BC78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 09:59:33 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Hi all,
> 
> 	I've had several requests for a more formal approach to the
> virtio draft spec, and (after some soul-searching) I'd like to try that.
> 
> 	The proposal is to use OASIS as the standards body, as it's
> fairly light-weight as these things go.  For me this means paperwork and
> setting up a Working Group and getting the right people involved as
> Voting members starting with the current contributors; for most of you
> it just means a new mailing list, though I'll be cross-posting any
> drafts and major changes here anyway.
> 
> 	I believe that a documented standard (aka virtio 1.0) will
> increase visibility and adoption in areas outside our normal linux/kvm
> universe.  There's been some of that already, but this is the clearest
> path to accelerate it.  Not the easiest path, but I believe that a solid
> I/O standard is a Good Thing for everyone.
> 
> 	Yet I also want to decouple new and experimental development
> from the standards effort; running code comes first.  New feature bits
> and new device numbers should be reservable without requiring a full
> spec change.
> 
> So the essence of my proposal is:
> 1) I start a Working Group within OASIS where we can aim for virtio spec
>    1.0.
> 
> 2) The current spec is textually reordered so the core is clearly
>    bus-independent, with PCI, mmio, etc appendices.
> 
> 3) Various clarifications, formalizations and cleanups to the spec text,
>    and possibly elimination of old deprecated features.
> 
> 4) The only significant change to the spec is that we use PCI
>    capabilities, so we can have infinite feature bits.
>    (see
> http://lists.linuxfoundation.org/pipermail/virtualization/2011-December/019198.html)

"Infinite" only applies to virtio-pci, no?

> 
> 5) Changes to the ring layout and other such things are deferred to a
>    future virtio version; whether this is done within OASIS or
>    externally depends on how well this works for the 1.0 release.
> 
> Thoughts?
> Rusty.
> 

Sounds like a good idea. I'll be happy to review the spec with an eye
to virtio-ccw.

Cornelia


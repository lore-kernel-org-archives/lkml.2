Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2I0CGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 22:06:22 -0400
Received: from ozlabs.org ([203.10.76.45]:46395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2I0CFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 22:05:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
        Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        Avishay Traeger <AVISHAY@il.ibm.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, Sasha Levin <levinsasha928@gmail.com>,
        "Cornelia Huck" <cornelia.huck@de.ibm.com>
Cc: <virtualization@lists.linux-foundation.org>,
        "LKML" <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        "qemu-devel" <qemu-devel@nongnu.org>
Subject: Proposal for virtio standardization.
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 27 Sep 2012 09:59:33 +0930
Message-ID: <87zk4c2tqq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

	I've had several requests for a more formal approach to the
virtio draft spec, and (after some soul-searching) I'd like to try that.

	The proposal is to use OASIS as the standards body, as it's
fairly light-weight as these things go.  For me this means paperwork and
setting up a Working Group and getting the right people involved as
Voting members starting with the current contributors; for most of you
it just means a new mailing list, though I'll be cross-posting any
drafts and major changes here anyway.

	I believe that a documented standard (aka virtio 1.0) will
increase visibility and adoption in areas outside our normal linux/kvm
universe.  There's been some of that already, but this is the clearest
path to accelerate it.  Not the easiest path, but I believe that a solid
I/O standard is a Good Thing for everyone.

	Yet I also want to decouple new and experimental development
from the standards effort; running code comes first.  New feature bits
and new device numbers should be reservable without requiring a full
spec change.

So the essence of my proposal is:
1) I start a Working Group within OASIS where we can aim for virtio spec
   1.0.

2) The current spec is textually reordered so the core is clearly
   bus-independent, with PCI, mmio, etc appendices.

3) Various clarifications, formalizations and cleanups to the spec text,
   and possibly elimination of old deprecated features.

4) The only significant change to the spec is that we use PCI
   capabilities, so we can have infinite feature bits.
   (see
http://lists.linuxfoundation.org/pipermail/virtualization/2011-December/019198.html)

5) Changes to the ring layout and other such things are deferred to a
   future virtio version; whether this is done within OASIS or
   externally depends on how well this works for the 1.0 release.

Thoughts?
Rusty.

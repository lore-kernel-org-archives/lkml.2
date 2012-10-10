Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2JJKCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 06:02:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab2JJKCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 06:02:20 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>, Adam Litke <agl@us.ibm.com>,
        Amit Shah <amit.shah@redhat.com>, Avi Kivity <avi@redhat.com>,
        Avishay Traeger <AVISHAY@il.ibm.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Pawel Moll <pawel.moll@arm.com>, Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: Proposal for virtio standardization.
In-Reply-To: <20121009160201.5303a7ca@BR9GNB5Z>
References: <87zk4c2tqq.fsf@rustcorp.com.au> <20121009160201.5303a7ca@BR9GNB5Z>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 10 Oct 2012 14:16:51 +1030
Message-ID: <87r4p76las.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> On Thu, 27 Sep 2012 09:59:33 +0930
> Rusty Russell <rusty@rustcorp.com.au> wrote:
>> 3) Various clarifications, formalizations and cleanups to the spec text,
>>    and possibly elimination of old deprecated features.
>> 
>> 4) The only significant change to the spec is that we use PCI
>>    capabilities, so we can have infinite feature bits.
>>    (see
>> http://lists.linuxfoundation.org/pipermail/virtualization/2011-December/019198.html)
>
> "Infinite" only applies to virtio-pci, no?

Yes, you already have "infinite" feature bits for ccw, as does every bus
we did since PCI.

> Sounds like a good idea. I'll be happy to review the spec with an eye
> to virtio-ccw.

Thanks!
Rusty.

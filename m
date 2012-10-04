Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab2JDBYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:24:09 -0400
Received: from ozlabs.org ([203.10.76.45]:42537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab2JDBYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:24:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lendacky <tahm@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, avi@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH 0/3] virtio-net: inline header support
In-Reply-To: <506C192E.5060700@redhat.com>
References: <cover.1348824232.git.mst@redhat.com> <87vces2gxq.fsf__45058.6618776017$1349247807$gmane$org@rustcorp.com.au> <506C192E.5060700@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 04 Oct 2012 09:41:12 +0930
Message-ID: <87bogj2j1b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 03/10/2012 08:44, Rusty Russell ha scritto:
>> There's a reason I haven't done this.  I really, really dislike "my
>> implemention isn't broken" feature bits.  We could have an infinite
>> number of them, for each bug in each device.
>
> However, this bug affects (almost) all implementations and (almost) all
> devices.  It even makes sense to reserve a transport feature bit for it
> instead of a device feature bit.
>
> Paolo

Perhaps, but we have to fix the bugs first!

As I said, my torture patch broke qemu immediately.  Since noone has
leapt onto fixing that, I'll take a look now...

Cheers,
Rusty.

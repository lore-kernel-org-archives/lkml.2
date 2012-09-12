Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2ILGdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:33:33 -0400
Received: from ozlabs.org ([203.10.76.45]:48427 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab2ILGd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:33:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fes@google.com, aarcange@redhat.com,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikew@google.com, yinghan@google.com,
        virtualization@lists.linux-foundation.org, yvugenfi@redhat.com,
        vrozenfe@redhat.com
Subject: Re: [PATCH] virtio-balloon spec: provide a version of the "silent deflate" feature that works
In-Reply-To: <20120910055150.GA16819@redhat.com>
References: <50487382.8030303@redhat.com> <20120906105301.GC32325@redhat.com> <5048935A.8090308@redhat.com> <87wr06hg0l.fsf@rustcorp.com.au> <20120907054202.GA3452@redhat.com> <87vcfqfia1.fsf@rustcorp.com.au> <20120907104306.GA17211@redhat.com> <87sjatf6iv.fsf@rustcorp.com.au> <20120908223724.GB20588@redhat.com> <87fw6qfya7.fsf@rustcorp.com.au> <20120910055150.GA16819@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 12 Sep 2012 15:54:28 +0930
Message-ID: <878vcfdahv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> We have several options:
> 1. No memory overcommit feature. This is always the case ATM!
> 2. Do not hot-plug assigned device.
> 3. Hot-unplug assigned device.
> 4. Some assigned devices can be able to handle memory errors
>    e.g. using ATS. Limit hotplug to these.

OK, let's leave it alone, and the first person to try to implement it in
a device can figure out how to fall back.

I replied on the other thread: I think a SILENT_DEFLATE option is
a future optimization.

Cheers,
Rusty.

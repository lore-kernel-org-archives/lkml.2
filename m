Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab2IFDCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 23:02:00 -0400
Received: from ozlabs.org ([203.10.76.45]:47000 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab2IFDAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 23:00:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
In-Reply-To: <20120905061219.GC7517@redhat.com>
References: <20120903044133.GA9980@moria.home.lan> <87wr0ae26e.fsf@rustcorp.com.au> <20120905061219.GC7517@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 06 Sep 2012 11:16:46 +0930
Message-ID: <87mx13j52x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Sep 04, 2012 at 03:53:53PM +0930, Rusty Russell wrote:
>> Kent Overstreet <koverstreet@google.com> writes:
>> 
>> > CONFIG_VIRTIO isn't exposed, everything else is supposed to select it
>> > instead.
>> 
>> This is a slight mis-understanding.  It's supposed to be selected by
>> the particular driver, probably virtio_pci in your case.
>> 
>> Cheers,
>> Rusty.
>
> Actually balloon selects VIRTIO, I think it's a bug.
> Also isn't it time we dropped the experimental tag?
> Leaving it in for now.

Thanks, I applied this, and killed the EXPERIMENTAL in a separate patch.

Cheers,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2JWCA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:00:58 -0400
Received: from ozlabs.org ([203.10.76.45]:60139 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756491Ab2JWCA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:00:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Cc: levinsasha928@gmail.com, Marc.Zyngier@arm.com,
        virtualization@lists.linux-foundation.org, akpm@linux-foundation.org,
        ericvh@gmail.com, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 1/3] mm: highmem: export kmap_to_page for modules
In-Reply-To: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
References: <1350651813-8694-1-git-send-email-will.deacon@arm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Oct 2012 10:25:57 +1030
Message-ID: <87objuhxiq.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Deacon <will.deacon@arm.com> writes:

> Some virtio device drivers (9p) need to translate high virtual addresses
> to physical addresses, which are inserted into the virtqueue for
> processing by userspace.
>
> This patch exports the kmap_to_page symbol, so that the affected drivers
> can be compiled as modules.

Thanks Will!

I've applied these, and add cc:stable.  I'll push them to Linus after a
little time in linux-next.

Cheers,
Rusty.

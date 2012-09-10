Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2IJCbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 22:31:11 -0400
Received: from ozlabs.org ([203.10.76.45]:38736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab2IJCaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 22:30:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Michael S. Tsirkin" <mst@redhat.com>,
        Asias He <asias@redhat.com>
Subject: Re: [ 84/95] virtio_blk: fix config handler race
In-Reply-To: <20120909224202.102918910@decadent.org.uk>
References: <20120909224202.102918910@decadent.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 10 Sep 2012 11:56:37 +0930
Message-ID: <87392qfw9u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> 3.2-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "Michael S. Tsirkin" <mst@redhat.com>
>
> commit 4678d6f970c2f7c0cbfefc0cc666432d153b321b upstream.
>
> Fix a theoretical race related to config work

???

>From Documentation/stable_kernel_rules.txt:

 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.

Similarly, '[ 85/95] virtio_blk: Drop unused request tracking list'
is a marginal perf improvement, why is it in there?

Neither of these were cc:stable; did someone request them specifically?

Confused,
Rusty.

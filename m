Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab1KBDZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 23:25:55 -0400
Received: from ozlabs.org ([203.10.76.45]:34312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab1KBDZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 23:25:51 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Peter Maydell <Peter.Maydell@arm.com>
Subject: Re: Additional virtio-mmio spec changes
In-Reply-To: <1320152499.3287.197.camel@hornet.cambridge.arm.com>
References: <1320152499.3287.197.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 02 Nov 2011 11:51:02 +1030
Message-ID: <87wrbjtj41.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Nov 2011 13:01:39 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> Hi Rusty,
> 
> Peter (on Cc) got the qemu implementation up and running (thanks!) and
> provided some useful feedback regarding the spec. To make the long story
> short, this is what came out of the discussion (feel free to correct me
> at any point, Peter ;-):

OK, I applied them manually.  One of the pains of using LyX is that you
need to turn change tracking on before making changes (I really like to
produce change-tracking versions of new spec releases).

> Of course those changes are not critical so can easily wait till the
> next release. Peter also mentioned that he didn't like the "Num" in
> "QueueNum" register name and would rather see it called "QueueSize". I
> have no strong opinions either way and can provide patches to both the
> spec and the driver (and header) to change it. Any thoughts?

Num isn't great, but Size might be misleading.  I'd leave it...

Thanks,
Rusty.

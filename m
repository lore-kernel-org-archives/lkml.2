Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876Ab2BLFqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 00:46:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41616 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2BLFqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 00:46:49 -0500
Subject: Re: [PATCH RFC v2] slab: introduce kmalloc_array
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Xi Wang <xi.wang@gmail.com>
In-Reply-To: <20120211121923.GA3341@p183.telecom.by>
Date: Sun, 12 Feb 2012 00:46:44 -0500
Cc: Jens Axboe <axboe@kernel.dk>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Matt Mackall <mpm@selenic.com>,
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <AC558223-1270-4343-934B-AB943054BADA@gmail.com>
References: <4F33BF05.208@gmail.com> <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <CACVxJT-+ycJmCZCOiuKaBbxCcnkgygfRtkeke06nb9DvPrT=kg@mail.gmail.com> <CACVxJT9gf0NkAuWWe02Q59HbjRB2WAJLJiRrrrFy5a46+po0eQ@mail.gmail.com> <3F3C1079-91B3-4AD4-97ED-EACAD3CB085F@gmail.com> <CACVxJT92s+XptSm+aNcbhNi0ovEwT0PSSCTiq=VYsbKDRKQWdw@mail.gmail.com> <C55D1711-151F-439C-8412-B9AFE09097DC@gmail.com> <20120211121923.GA3341@p183.telecom.by>
To: Alexey Dobriyan <adobriyan@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 11, 2012, at 7:19 AM, Alexey Dobriyan wrote:
> But there is no misuse.
> 
> Both kaalloc(non-const, const) and kaalloc(const, non-const) are OK.
> It's just first case happens more often.

Any k*alloc(const, non-const) example?  I feel like in most cases
it is the caller code that should get fixed, such as:

https://lkml.org/lkml/2012/2/10/135

- xi

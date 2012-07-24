Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2GXTjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:39:47 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65423 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2GXTjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:39:46 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
References: <20120724181209.GA10534@zod.bos.redhat.com> <CA+55aFw-=vY1eAubQAtbqL33nCrQ7mPgXTaHnEJfbKvFDVdHtw@mail.gmail.com>
 <20120724182409.GB10534@zod.bos.redhat.com> <500EF541.50009@redhat.com> <CA+55aFwSHae5rgFP_b_+r9Agz9JfM9QdoNbZTq7u+5G-xrr8RQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 12:39:25 -0700
X-Google-Sender-Auth: DC3B-m6m9vxc_FHmjwcsLMuczmw
Message-ID: <CA+55aFxEcA3w_1AmCnUG_iEB1LuCnYKbW+hcCSe65UjQahp2_Q@mail.gmail.com>
Subject: Re: [PATCH] posix_types.h: make __NFDBITS match glibc definition
To: Jeff Law <law@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> .. and it causes other problems instead, namely the crap code generation for __.

oops. Edit error. That __ should be __FDELT/__FDMASK.

But note that those are only the internal kernel macros that aren't
even *used* by the kernel. They are some left-over from olden days,
and seem to only cause odd interactions with glibc.

                 Linus

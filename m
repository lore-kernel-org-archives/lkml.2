Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab1ISTUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:20:20 -0400
Received: from mail-ew0-f45.google.com ([209.85.215.45]:61709 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1ISTUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <20110919185518.GA5563@albatros>
References: <20110919144657.GA5928@albatros>
	<CAOJsxLG8gW=BLOptpULsaAEwTravADKbNbXp5e9Wd7xVEfR9AQ@mail.gmail.com>
	<20110919155718.GB16272@albatros>
	<CAOJsxLGZm+npcR0YgXSE2wLC2iXCtzYyCdTDCt1LN=Z28Rm_UA@mail.gmail.com>
	<20110919161837.GA2232@albatros>
	<CAOJsxLE2od0f+6cbL2hA_31CbrqS7AUofx5DT2L9fO_7gxH+PQ@mail.gmail.com>
	<20110919173539.GA3751@albatros>
	<CAOJsxLGc0bwCkDtk2PVe7c155a9wVoDAY0CmYDTLg8_bL4qxqg@mail.gmail.com>
	<20110919175856.GA4282@albatros>
	<CAOJsxLFdNVnW6Faap0UaqZQDQxbA_dEiR2HGdzZtGMJFsVR1WQ@mail.gmail.com>
	<20110919185518.GA5563@albatros>
Date: Mon, 19 Sep 2011 22:20:16 +0300
X-Google-Sender-Auth: aCvGNHgqCOZPybvd_sLgAKUjrGc
Message-ID: <CAOJsxLHWu7gm94MvFOcbrjW33AqpD7i+kYL1+mEMt=4cS53GhA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC PATCH 2/2] mm: restrict access to /proc/slabinfo
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <kees@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Theodore Tso <tytso@mit.edu>, Alan Cox <alan@linux.intel.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 9:55 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> Oh, we also have perf...  Given these are separate interfaces, I think
> slab oriented restriction makes more sense.
>
> So, now we have:
>
> /proc/slabinfo
> /sys/kernel/slab
> /proc/meminfo
> 'perf kmem' - not sure what specific files should be guarded

I don't think you can close down 'perf kmem' per se. You need to make
sure the attacker is not able to use perf tracing (of which 'perf kmem' is
a subset).

                       Pekka

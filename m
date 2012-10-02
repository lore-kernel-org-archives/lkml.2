Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2JBWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 18:38:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab2JBWim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 18:38:42 -0400
Date: Tue, 2 Oct 2012 15:38:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@gmail.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
Message-Id: <20121002153841.a03ad73b.akpm@linux-foundation.org>
In-Reply-To: <CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012 15:10:56 -0700
Kees Cook <keescook@chromium.org> wrote:

> >> Has there been any more progress on this patch over-all?
> >
> > No progress.
> 
> Al, Andrew, anyone? Thoughts on this?
> (First email is https://lkml.org/lkml/2012/8/14/448)

Wasn't cc'ed, missed it.

The patch looks straightforward enough.  Have the maintainers of the
runtime linker (I guess that's glibc) provided any feedback on the
proposal?

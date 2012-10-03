Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2JCWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:25:28 -0400
Received: from toast.topped-with-meat.com ([204.197.218.159]:54572 "EHLO
	topped-with-meat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2JCWZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:25:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@hack.frob.com>
To: Kees Cook <keescook@chromium.org>
X-Fcc: ~/Mail/lkml
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@gmail.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        pageexec@freemail.hu
Subject: Re: Updated: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
In-Reply-To: Kees Cook's message of  Wednesday, 3 October 2012 15:19:26 -0700 <CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
References: <E1T1N2q-0001xm-5X@morero.ard.nu>
	<20120820180037.GV4232@outflux.net>
	<CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com>
	<CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com>
	<CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
	<CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com>
	<20121002153841.a03ad73b.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
	<506C4F29.4090303@gmail.com>
	<20121003141804.f9896690.akpm@linux-foundation.org>
	<CAGXu5jLY8kFaTMNetqnO_PHwkCCfqkaTxTZQdSc1AwcDiAr86g@mail.gmail.com>
X-Windows: power tools for power fools.
Message-Id: <20121003222524.25D522C07E@topped-with-meat.com>
Date: Wed,  3 Oct 2012 15:25:24 -0700 (PDT)
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.0 cv=LtfpOghc c=1 sm=1 a=83vJHjYcsLoA:10
		a=Z6MIti7PxpgA:10 a=kj9zAlcOel0A:10 a=hOe2yjtxAAAA:8 a=14OXPxybAAAA:8
		a=hDOdbiMiwYMA:10 a=D19gQVrFAAAA:8 a=CCpqsmhAAAAA:8
		a=PsdQtnzvci5p8BR0jpwA:9 a=CjuIK1q_8ugA:10 a=4t78-hnhQh4A:10
		a=WkljmVdYkabdwxfqvArNOQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Again: has this proposal been reviewed by the glibc maintainers?  If
> > so, what was their position on it?
> 
> Ard have you talked with them? I would expect it would be welcomed.
> Roland, do you know who would be the right person to ask about this
> for glibc? (patch: https://lkml.org/lkml/2012/10/3/262)

It's me and others.  Someone should post (avoiding lots of cross-posting,
please) to libc-alpha@sourceware.org with a straightforward description of
the userland semantics being introduced (we don't need to see kernel
patches) and (ideally) a proposed patch for the dynamic linker code to make
use of it (a strawman example is OK to begin with).


Thanks,
Roland

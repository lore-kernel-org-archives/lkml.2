Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2JISmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:42:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2JISl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:41:59 -0400
Date: Tue, 9 Oct 2012 11:41:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: Daniel Santos <danielfsantos@att.net>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-Id: <20121009114158.9cdf1378.akpm@linux-foundation.org>
In-Reply-To: <5071C9AE.2010106@att.net>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
	<1349466169-20637-3-git-send-email-daniel.santos@pobox.com>
	<20121006231041.GB3278@liondog.tnic>
	<5071C9AE.2010106@att.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Oct 2012 13:27:58 -0500
Daniel Santos <danielfsantos@att.net> wrote:

> We'll have to ask Andrew.  Maybe so he can test on those versions of gcc?
> 
> commit d3ffe64a1dbcfe18b57f90f7c01c40c93d0a8b92
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Fri Sep 28 00:02:42 2012 +0000
> 
>     a
>    
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 934bc34..997fd8a 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -5,7 +5,7 @@
>  /* GCC 4.1.[01] miscompiles __weak */
>  #ifdef __KERNEL__
>  # if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
> -#  error Your version of gcc miscompiles the __weak directive
> +//#  error Your version of gcc miscompiles the __weak directive

hm, yeah, sorry, I use various old crufty cross-compilers.

There are quite a number of patches in -mm which aren't included in
linux-next and that's one of them.  The
NEXT_PATCHES_START/NEXT_PATCHES_END markers in the series file identify
the patches which Stephen selects.

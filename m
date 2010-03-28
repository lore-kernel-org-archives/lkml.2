Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0C1Nqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 09:46:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38769 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab0C1Nq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 09:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tB3Zdbo/A2wRDOhubnYjaAw95a5yZOQCC+HPqWQVAgEAyJy7kakYDFj104oeSqLcXE
         cK/BQ2m9/Bpsu3JNt09Wqb5jQid1C2YIbWBI+tA+z81XdFb5rHeoR6wOBzaFLBmnF5pK
         c99fY8c4M2NrdNCMt4O7X2gcq8KETMoBN2t28=
Date: Sun, 28 Mar 2010 17:19:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jan III Sobieski <jan3sobi3ski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add random binaries to .gitignore
Message-ID: <20100328141957.GA3689@core2>
References: <4BAF4DAF.70609@gmail.com>
 <20100328133500.GB3622@core2>
 <4BAF5BD7.1060208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAF5BD7.1060208@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 03:38:31PM +0200, Jan III Sobieski wrote:
> W dniu 2010-03-28 15:35, Alexey Dobriyan pisze:
> > On Sun, Mar 28, 2010 at 02:38:07PM +0200, Jan III Sobieski wrote:
> >> +# random binary files
> >> +Documentation/filesystems/dnotify_test
> >> +Documentation/laptops/dslm
> >> +Documentation/timers/hpet_example
> >> +Documentation/vm/hugepage-mmap
> >> +Documentation/vm/hugepage-shm
> >> +Documentation/vm/map_hugetlb
> >> +arch/x86/boot/compressed/vmlinux
> >> +arch/x86/tools/test_get_len
> > 
> > This should go to per-directory gitiignores.
> 
> I agree that it is not the best solution. But one directory one
> .gitignore also isn't the best, so I propose this

.gitignore in leaf directory is the status quo.

	find . -type f -name '\.gitignore'

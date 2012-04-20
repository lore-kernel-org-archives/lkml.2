Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab2DTTck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:32:40 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:64835 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab2DTTcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120420192937.GE15021@tiehlicka.suse.cz>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
	<20120420182907.GG32324@google.com>
	<20120420191418.GA3569@merkur.ravnborg.org>
	<20120420192937.GE15021@tiehlicka.suse.cz>
Date: Fri, 20 Apr 2012 12:32:38 -0700
X-Google-Sender-Auth: rZC6S8WuiwzSgEMFcxY20cXI-TA
Message-ID: <CAE9FiQUytfCvr8c++im+DignUwZvHmnu8gPNDG6SOJzrF_FsNg@mail.gmail.com>
Subject: Re: Weirdness in __alloc_bootmem_node_high
From: Yinghai Lu <yinghai@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 12:29 PM, Michal Hocko <mhocko@suse.cz> wrote:
> This is what I can see in the current (Linus) git:
> ./arch/sparc/Kconfig:   select SPARSEMEM_VMEMMAP_ENABLE
> ./arch/powerpc/Kconfig: select SPARSEMEM_VMEMMAP_ENABLE
> ./arch/ia64/Kconfig:    select SPARSEMEM_VMEMMAP_ENABLE
> ./arch/s390/Kconfig:    select SPARSEMEM_VMEMMAP_ENABLE
> ./arch/s390/Kconfig:    select SPARSEMEM_VMEMMAP
> ./arch/x86/Kconfig:     select SPARSEMEM_VMEMMAP_ENABLE if X86_64
>
> So there are more arches which enable SPARSEMEM_VMEMMAP so the function
> is used. Or am I missing something?

MAX_DMA32_PFN is not defined for them.

I was think only x86 have that define. Actually mips have that defined too.

Yinghai

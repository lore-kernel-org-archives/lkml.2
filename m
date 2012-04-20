Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2DTTlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:41:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab2DTTlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:41:23 -0400
Date: Fri, 20 Apr 2012 21:41:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Weirdness in __alloc_bootmem_node_high
Message-ID: <20120420194121.GF15021@tiehlicka.suse.cz>
References: <20120417155502.GE22687@tiehlicka.suse.cz>
 <20120420182907.GG32324@google.com>
 <20120420191418.GA3569@merkur.ravnborg.org>
 <20120420192937.GE15021@tiehlicka.suse.cz>
 <CAE9FiQUytfCvr8c++im+DignUwZvHmnu8gPNDG6SOJzrF_FsNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQUytfCvr8c++im+DignUwZvHmnu8gPNDG6SOJzrF_FsNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 20-04-12 12:32:38, Yinghai Lu wrote:
> On Fri, Apr 20, 2012 at 12:29 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > This is what I can see in the current (Linus) git:
> > ./arch/sparc/Kconfig:   select SPARSEMEM_VMEMMAP_ENABLE
> > ./arch/powerpc/Kconfig: select SPARSEMEM_VMEMMAP_ENABLE
> > ./arch/ia64/Kconfig:    select SPARSEMEM_VMEMMAP_ENABLE
> > ./arch/s390/Kconfig:    select SPARSEMEM_VMEMMAP_ENABLE
> > ./arch/s390/Kconfig:    select SPARSEMEM_VMEMMAP
> > ./arch/x86/Kconfig:     select SPARSEMEM_VMEMMAP_ENABLE if X86_64
> >
> > So there are more arches which enable SPARSEMEM_VMEMMAP so the function
> > is used. Or am I missing something?
> 
> MAX_DMA32_PFN is not defined for them.

Ahh, you are right except that it is defined for x86 but that one uses
nobootmem. I missed that point.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

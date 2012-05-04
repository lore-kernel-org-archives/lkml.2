Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2EDTav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:30:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33505 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2EDTau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:30:50 -0400
Date: Fri, 4 May 2012 15:24:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, hpa@linux.intel.com,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH] Expand memblock=debug to provide a bit more details
 (v1).
Message-ID: <20120504192459.GA5684@phenom.dumpdata.com>
References: <1336157382-14548-1-git-send-email-konrad.wilk@oracle.com>
 <CAE9FiQWOps3Hmw=p6mWObRnu2KHVNshpoY+uWcAAQd1Yxi54yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAE9FiQWOps3Hmw=p6mWObRnu2KHVNshpoY+uWcAAQd1Yxi54yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 12:22:58PM -0700, Yinghai Lu wrote:
> On Fri, May 4, 2012 at 11:49 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > While trying to track down some memory allocation issues, I realized that
> > memblock=debug was giving some information, but for guests with 256GB or
> > so the majority of it was just:
> >
> >  memblock_reserve: [0x00003efeeea000-0x00003efeeeb000] __alloc_memory_core_early+0x5c/0x64
> >
> > which really didn't tell me that much. With these patches I know it is:
> >
> >  memblock_reserve: [0x00003ffe724000-0x00003ffe725000] (4kB) vmemmap_pmd_populate+0x4b/0xa2
> >
> > .. which isn't really that useful for the problem I was tracking down, but
> > it does help in figuring out which routines are using memblock.
> >
> 
> that RET_IP is not very helpful for debugging.

Is there a better way of doing it that is automatic?
> 
> Actually I have local debug patch for memblock. please check if that
> is going to help debugging.
> 
> Thanks
> 
> Yinghai




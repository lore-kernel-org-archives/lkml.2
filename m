Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2GMP4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:56:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:51697 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab2GMP4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="171502344"
Date: Fri, 13 Jul 2012 08:56:32 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@gmail.com>, linux-kernel@vger.kernel.org,
        "Jonathan M. Foote" <jmfoote@cert.org>,
        "H. J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [PATCH v2] Extend core dump note section to contain file names
 of mapped files
Message-ID: <20120713155632.GA30239@tassilo.jf.intel.com>
References: <201207122142.02137.vda.linux@googlemail.com>
 <20120713145806.GA17217@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713145806.GA17217@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 04:58:06PM +0200, Oleg Nesterov wrote:
> On 07/12, Denys Vlasenko wrote:
> >
> > This note has the following format:
> >
> > long count     -- how many files are mapped
> > long page_size -- units for file_ofs
> > array of [COUNT] elements of
> >    long start
> >    long end
> >    long file_ofs
> > followed by COUNT filenames in ASCII: "FILE1" NUL "FILE2" NUL...
> 
> All I can say, I believe the patch is correct.

Patch looks good to me too.

> Otherwise I can't comment the patch, I simply do not know what
> people do with the coredumps. But Denys certainly knows, he works
> with the tools which need this info.

More information during debugging is always good.

I assume there will be a gdb patch to dump it?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

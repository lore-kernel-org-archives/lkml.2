Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab2HXNXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:23:34 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56842 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2HXNXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:23:30 -0400
Date: Fri, 24 Aug 2012 15:23:11 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Jovi Zhang <bookjovi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mips@linux-mips.org,
        Youquan Song <youquan.song@intel.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] MIPS/mm: add compound tail page _mapcount when mapped
Message-ID: <20120824132311.GG10439@linux-mips.org>
References: <CACV3sb+nocqeDiM+4m+hv1ygu=KAxD6CpR5wQmawkKMdAuXbgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACV3sb+nocqeDiM+4m+hv1ygu=KAxD6CpR5wQmawkKMdAuXbgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:02:34AM +0800, Jovi Zhang wrote:

> see commit b6999b191 which target for x86 mm/gup, let it align with
> mips architecture.
> 
> Quote from commit b6999b191:
>     "If compound pages are used and the page is a
>     tail page, gup_huge_pmd() increases _mapcount to record tail page are
>     mapped while gup_huge_pud does not do that."

Thanks, applied and also acked' for -stable.

Note the patch got linewrapped along the way but it's trivial enough to be
fixed up.

  Ralf

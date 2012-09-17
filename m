Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2IQS3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:29:51 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38573 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab2IQS3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:29:50 -0400
Date: Mon, 17 Sep 2012 14:18:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 11/11] xen/mmu: Release just the MFN list,
 not MFN list and part of pagetables.
Message-ID: <20120917181858.GA17720@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-12-git-send-email-konrad.wilk@oracle.com>
 <CAJ75kXYG3uPmMhUwB9ivHt0w5gm14aqAynSWQwooWg65xLTzPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXYG3uPmMhUwB9ivHt0w5gm14aqAynSWQwooWg65xLTzPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 08:06:26PM +0200, William Dauchy wrote:
> Hello Konrad,
> 
> On Thu, Aug 16, 2012 at 6:03 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > (XEN) mm.c:908:d0 Error getting mfn 116a83 (pfn 14e2a) from L1 entry 8000000116a83067 for l1e_owner=0, pg_owner=0
> > (XEN) mm.c:908:d0 Error getting mfn 4040 (pfn 5555555555555555) from L1 entry 0000000004040601 for l1e_owner=0, pg_owner=0
> 
> This is something I also have on my 3.4.x branch. Since then mmu.c has
> change a lot; is there an easy fix to make a backport for 3.4.x?

Uhh, can you open a new email thread with the error you are seeing and
please include the full serial log along with dmidecode pls?

> 
> -- 
> William

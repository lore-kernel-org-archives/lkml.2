Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab0JCS1I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:27:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53948 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab0JCS1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:27:05 -0400
Date: Sun, 3 Oct 2010 23:57:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Robin Holt <holt@sgi.com>, Nathan Fontenot <nfont@austin.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, steiner@sgi.com
Subject: Re: [PATCH 7/9] v3 Define memory_block_size_bytes for powerpc/pseries
Message-ID: <20101003182701.GI7896@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62A0A.4050406@austin.ibm.com>
 <20101003175500.GE7896@balbir.in.ibm.com>
 <20101003180731.GT14064@sgi.com>
 <1286129461.9970.1.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1286129461.9970.1.camel@nimitz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen <dave@linux.vnet.ibm.com> [2010-10-03 11:11:01]:

> On Sun, 2010-10-03 at 13:07 -0500, Robin Holt wrote:
> > On Sun, Oct 03, 2010 at 11:25:00PM +0530, Balbir Singh wrote:
> > > * Nathan Fontenot <nfont@austin.ibm.com> [2010-10-01 13:35:54]:
> > > 
> > > > Define a version of memory_block_size_bytes() for powerpc/pseries such that
> > > > a memory block spans an entire lmb.
> > > 
> > > I hope I am not missing anything obvious, but why not just call it
> > > lmb_size, why do we need memblock_size?
> > > 
> > > Is lmb_size == memblock_size after your changes true for all
> > > platforms?
> > 
> > What is an lmb?  I don't recall anything like lmb being referred to in
> > the rest of the kernel.
> 
> Heh.  It's the OpenFirmware name for a Logical Memory Block.  Basically
> what we use to determine the SECTION_SIZE on powerpc.  Probably not the
> best terminology to use elsewhere in the kernel.

Agreed for the kernel, this patch was for powerpc/pseries, hence was
checking in this context.

-- 
	Three Cheers,
	Balbir

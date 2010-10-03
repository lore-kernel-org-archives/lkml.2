Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0JCSLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:11:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47656 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab0JCSLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:11:05 -0400
Subject: Re: [PATCH 7/9] v3 Define memory_block_size_bytes for
 powerpc/pseries
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Robin Holt <holt@sgi.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, steiner@sgi.com
In-Reply-To: <20101003180731.GT14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
	 <4CA62A0A.4050406@austin.ibm.com> <20101003175500.GE7896@balbir.in.ibm.com>
	 <20101003180731.GT14064@sgi.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 03 Oct 2010 11:11:01 -0700
Message-ID: <1286129461.9970.1.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 13:07 -0500, Robin Holt wrote:
> On Sun, Oct 03, 2010 at 11:25:00PM +0530, Balbir Singh wrote:
> > * Nathan Fontenot <nfont@austin.ibm.com> [2010-10-01 13:35:54]:
> > 
> > > Define a version of memory_block_size_bytes() for powerpc/pseries such that
> > > a memory block spans an entire lmb.
> > 
> > I hope I am not missing anything obvious, but why not just call it
> > lmb_size, why do we need memblock_size?
> > 
> > Is lmb_size == memblock_size after your changes true for all
> > platforms?
> 
> What is an lmb?  I don't recall anything like lmb being referred to in
> the rest of the kernel.

Heh.  It's the OpenFirmware name for a Logical Memory Block.  Basically
what we use to determine the SECTION_SIZE on powerpc.  Probably not the
best terminology to use elsewhere in the kernel.

-- Dave


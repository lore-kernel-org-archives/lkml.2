Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab0JCSHh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 14:07:37 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51788 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182Ab0JCSHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 14:07:36 -0400
Date: Sun, 3 Oct 2010 13:07:31 -0500
From: Robin Holt <holt@sgi.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 7/9] v3 Define memory_block_size_bytes for
 powerpc/pseries
Message-ID: <20101003180731.GT14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62A0A.4050406@austin.ibm.com>
 <20101003175500.GE7896@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101003175500.GE7896@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 03, 2010 at 11:25:00PM +0530, Balbir Singh wrote:
> * Nathan Fontenot <nfont@austin.ibm.com> [2010-10-01 13:35:54]:
> 
> > Define a version of memory_block_size_bytes() for powerpc/pseries such that
> > a memory block spans an entire lmb.
> 
> I hope I am not missing anything obvious, but why not just call it
> lmb_size, why do we need memblock_size?
> 
> Is lmb_size == memblock_size after your changes true for all
> platforms?

What is an lmb?  I don't recall anything like lmb being referred to in
the rest of the kernel.

Robin

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1EZMjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:39:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55428 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab1EZMjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:39:40 -0400
Date: Thu, 26 May 2011 08:39:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Greg KH <greg@kroah.com>, kevin.tian@intel.com, dkiper@net-space.pl
Cc: Rzeszutek@dumpdata.com, Wilk@dumpdata.com, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Message-ID: <20110526123921.GB3386@dumpdata.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
 <20110526070239.GB29833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526070239.GB29833@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DDE4A04.007C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 12:02:39AM -0700, Greg KH wrote:
> On Wed, May 25, 2011 at 05:37:32PM -0400, Konrad@dumpdata.com wrote:
> > Hey stable-tree maintainer(s).
> > 
> > The follow four patches are in the 2.6.40 tree and should be back-ported to 2.6.39 (only).
> > I forgot to CC:stable on them, so manually doing it here.
> > 
> > The four patches in question have the following git commits:
> > 
> > 8c5950881c3b5e6e350e4b0438a8ccc513d90df9
> >     xen/p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
> > 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
> >     xen/setup: Fix for incorrect xen_extra_mem_start initialization under 32-bit
> > 15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4
> >     xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
> > 7899891c7d161752f29abcc9bc0a9c6c3a3af26c
> >     xen mmu: fix a race window causing leave_mm BUG()
> > 
> > And are part of this email chain. Please apply them to 2.6.39.1 tree.
> 
> I need an ack from the Xen maintainer and the original patch author
> before I can accept these.  Please get them to provide this and I will

OK

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

(who is the Xen maintainer)

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
(who is also the original patch author on some of the patches)

Daniel and Kevin, can you guys Ack them please?

> be glad to queue them up.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

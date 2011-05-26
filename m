Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab1EZMpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:45:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:35572 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757500Ab1EZMpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:45:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="2261299"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Greg KH <greg@kroah.com>,
        "dkiper@net-space.pl" <dkiper@net-space.pl>
CC: "Rzeszutek@dumpdata.com" <Rzeszutek@dumpdata.com>,
        "Wilk@dumpdata.com" <Wilk@dumpdata.com>,
        "stable@kernel.org" <stable@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 May 2011 20:44:47 +0800
Subject: RE: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Thread-Topic: [stable] [PATCH] Xen bug-fixes for 2.6.39 (already in 2.6.40)
Thread-Index: Acwbofh8ILgmqGukRKqsQEQBTuAGwQAAKszw
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C9C008822@shsmsx502.ccr.corp.intel.com>
References: <1306359456-3627-1-git-send-email-konrad.wilk@oracle.com>
 <20110526070239.GB29833@kroah.com> <20110526123921.GB3386@dumpdata.com>
In-Reply-To: <20110526123921.GB3386@dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Konrad Rzeszutek Wilk [mailto:konrad.wilk@oracle.com]
> Sent: Thursday, May 26, 2011 8:39 PM
> 
> On Thu, May 26, 2011 at 12:02:39AM -0700, Greg KH wrote:
> > On Wed, May 25, 2011 at 05:37:32PM -0400, Konrad@dumpdata.com wrote:
> > > Hey stable-tree maintainer(s).
> > >
> > > The follow four patches are in the 2.6.40 tree and should be back-ported to
> 2.6.39 (only).
> > > I forgot to CC:stable on them, so manually doing it here.
> > >
> > > The four patches in question have the following git commits:
> > >
> > > 8c5950881c3b5e6e350e4b0438a8ccc513d90df9
> > >     xen/p2m: Create entries in the P2M_MFN trees's to track 1-1
> mappings
> > > 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3
> > >     xen/setup: Fix for incorrect xen_extra_mem_start initialization under
> 32-bit
> > > 15bfc094517db2ddf38ca7ed47f3a1c0ad24f7c4
> > >     xen/setup: Ignore E820_UNUSABLE when setting 1-1 mappings.
> > > 7899891c7d161752f29abcc9bc0a9c6c3a3af26c
> > >     xen mmu: fix a race window causing leave_mm BUG()
> > >
> > > And are part of this email chain. Please apply them to 2.6.39.1 tree.
> >
> > I need an ack from the Xen maintainer and the original patch author
> > before I can accept these.  Please get them to provide this and I will
> 
> OK
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> (who is the Xen maintainer)
> 
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> (who is also the original patch author on some of the patches)
> 
> Daniel and Kevin, can you guys Ack them please?
> 

Acked-by: Kevin Tian <kevin.tian@intel.com>

Thanks
Kevin

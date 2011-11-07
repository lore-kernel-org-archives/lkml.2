Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab1KGQqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:46:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:24684 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1KGQqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:46:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,470,1315206000"; 
   d="scan'208";a="71428752"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 7 Nov 2011 08:46:35 -0800
Subject: RE: linux-next: build failure after merge of the origin tree
Thread-Topic: linux-next: build failure after merge of the origin tree
Thread-Index: AcydDjzzNn/sMOVzTpeMq++Cpu1XowAXlbzw
Message-ID: <43F901BD926A4E43B106BF17856F075501A1CCA399@orsmsx508.amr.corp.intel.com>
References: <20111107101202.96fcb76d580e5265bd99aeee@canb.auug.org.au>
 <20111106.205259.1237400984015921904.davem@davemloft.net>
 <20111107134706.3e7fc633f913b5e155153127@canb.auug.org.au>
 <20111106.223619.1348742215191441592.davem@davemloft.net>
 <EAE7BD3E-8965-47A4-B3CA-01686E2602C2@intel.com>
In-Reply-To: <EAE7BD3E-8965-47A4-B3CA-01686E2602C2@intel.com>
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



> -----Original Message-----
> From: Kirsher, Jeffrey T
> Sent: Sunday, November 06, 2011 9:30 PM
> To: David Miller
> Cc: sfr@canb.auug.org.au; torvalds@linux-foundation.org; linux-
> next@vger.kernel.org; linux-kernel@vger.kernel.org; Rose, Gregory V;
> netdev@vger.kernel.org
> Subject: Re: linux-next: build failure after merge of the origin tree
> 
> 
> 
> Cheers,
> Jeff
> 
> On Nov 6, 2011, at 19:38, "David Miller" <davem@davemloft.net> wrote:
> 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 7 Nov 2011 13:47:06 +1100
> >
> >>> If you just revert the commit in origin from -next, then you will get
> >>> conflicts with you pull the net.git tree in.
> >>
> >> I got no conflicts when I merged in the net tree and can see no fix for
> >> this problem in the net tree.  My current head of the net tree is
> 1a6422f
> >> "etherh: Add MAINTAINERS entry for etherh".
> >
> > Ok, Jeff please take a look at this and send me a fix soon.
> >
> > Thanks.
> 
> Ok Dave, at this point, I am puttying together a patch to revert this fix
> since it appears that more trouble comes with this fix.  I will take a
> look at it quickly before sending out a patch to fix the issue.

My bad...  I fixed a compiler warning that occurred with CONFIG_PCI_IOV turned on and didn't realize that my patch would cause an error when turning it back off.

I'll have it fixed ASAP.

- Greg


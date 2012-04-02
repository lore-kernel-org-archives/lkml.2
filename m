Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2DBXlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:41:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:62538 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab2DBXlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:41:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="127978547"
Subject: Re: Don't apply 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 to stable
 please.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, stable@vger.kernel.org
Date: Mon, 02 Apr 2012 16:43:05 -0700
In-Reply-To: <20120402232750.GB17821@kroah.com>
References: <20120402224701.GA6961@phenom.dumpdata.com>
	 <20120402232750.GB17821@kroah.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1333410186.1270.92.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-02 at 16:27 -0700, Greg KH wrote:
> On Mon, Apr 02, 2012 at 06:47:02PM -0400, Konrad Rzeszutek Wilk wrote:
> > Hey Greg,
> > 
> > The git commit 9f022e54b8ea82d1ecdf3bd78d9ab9f44d6b0655 has CC stable@kernel.org
> > but it breaks Xen - we are working to fix it in 3.4, but the fix for it
> > does some architectual changes (136d249ef7dbf0fefa292082cc40be1ea864cbd6) that
> > I don't know if you are comfortable putting in stable tree.
> > 
> 
> I have no idea what that git commit id referrs to, as it's not in
> Linus's tree at the moment.
> 
> Care to give me a subject?  diffstat?  Some kind of hint?

Greg, Konrad is referring to:

commit 73d63d038ee9f769f5e5b46792d227fe20e442c5
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Mon Mar 12 11:36:33 2012 -0700

    x86/ioapic: Add register level checks to detect bogus io-apic entries

With out this commit, if the bios lists bogus io-apic's, then we will
see some error messages ("Unable to reset IRR for apic")during linux
boot which are benign. But as this patch breaks Xen, I am ok if these
don't get applied to 'stable'. Also I think it is Ingo who added the
'stable' tag. Ingo, are you ok with this?

For the mainline, we have queued more patches to fix the Xen breakage.

thanks,
suresh

> 
> And note, you forgot to send this to the stable@vger.kernel.org list,
> where the other stable kernel maintainers live, please do so next time.
> 
> thanks,
> 
> greg k-h



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1GTUYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1GTUYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:24:45 -0400
Date: Wed, 20 Jul 2011 16:24:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110720202429.GE10079@redhat.com>
References: <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
 <20110718152532.GF31986@redhat.com>
 <1311012188.4427.58.camel@br98xy6r>
 <20110719150423.GA7001@redhat.com>
 <1311154115.3829.17.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311154115.3829.17.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:28:35AM +0200, Michael Holzheu wrote:

[..]
> > > What you as kdump framework maintainer would have to accept with this
> > > solution is that it is allowed now to start kdump directly via purgatory
> > > without using code from the old kernel (e.g. crash_kexec). This has as
> > > implication that all things that the old kernel has to initialize for
> > > kdump has to be done before the system crashes. Currently this is only
> > > the initialization of vmcoreinfo.
> > 
> > when would you save vmcoreinfo? I guess I shall have to look at the
> > patches.
> 
> patch #4: We have to save vmcoreinfo at startup time of the production
> kernel.
> 
> Perhaps it would be best to send you a new patch series with our latest
> proposal.

This patch 4 looks reasonable. So you will prepare notes after boot and
refresh it after adding CRASHTIME if crash_kexec() is executed.

Vivek

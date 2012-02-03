Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2BCEVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 23:21:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:24175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab2BCEVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 23:21:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="105749242"
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Lin Ming <ming.m.lin@intel.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        jeff@garzik.org, Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1328231716.15079.15.camel@minggr>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
	 <4F2A4B7E.2090503@linux.vnet.ibm.com>  <1328231716.15079.15.camel@minggr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Feb 2012 12:21:24 +0800
Message-ID: <1328242884.15079.22.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 09:15 +0800, Lin Ming wrote:
> On Thu, 2012-02-02 at 14:08 +0530, Srivatsa S. Bhat wrote:
> > Adding some Cc's.
> > 
> > On 02/02/2012 10:42 AM, Norbert Preining wrote:
> > 
> > > Dear all,
> > > 
> > > (please Cc)
> > > 
> > > since going from 3.2 to 3.3-rc1 I see a kind of regression wrt booting
> > > time, namely the detection of the CD drive hangs for 10sec (both
> > > dmesg were taken on the same hardware on the same day):
> > > 
> > > with 3.3-rc1 and rc2:
> > > [    3.694012] sd 0:0:0:0: [sda] Attached SCSI disk
> > > [    9.004013] ata2: link is slow to respond, please be patient (ready=0)
> > > [   13.652013] ata2: COMRESET failed (errno=-16)
> > > [   13.972022] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> 
> I'm looking into this problem.
> But I can't reproduce this regression.
> 
> Could you attach the full 3.3-rc2 dmesg?

And could you do a bisect?

First, you can check if commit 318893e is good or bad.

If it's bad, then you only need to do a bisect between v3.2 and 318893e.
Otherwise, you need to do a bisect between v3.2 and v3.3-rc1.

Thanks,
Lin Ming


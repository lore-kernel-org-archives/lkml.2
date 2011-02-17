Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1BQOiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:38:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47633 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1BQOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 09:38:17 -0500
X-IronPort-AV: E=Sophos;i="4.60,486,1291611600"; 
   d="scan'208";a="136336905"
Subject: Re: [Xen-devel] [PATCH] Xen PCI fronted fixes for 2.6.39
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110217142807.GD5987@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
	 <1297931344.16356.1268.camel@zakaz.uk.xensource.com>
	 <20110217142807.GD5987@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 17 Feb 2011 14:38:14 +0000
Message-ID: <1297953494.16356.1738.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 14:28 +0000, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 17, 2011 at 08:29:04AM +0000, Ian Campbell wrote:
> > On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > > I am proposing these three patches for 2.6.39.
> > > 
> > > The first is to take advantage of the new method of requesting
> > > a Linux IRQ and providing the Xen PIRQ value. The second
> > > makes it possible for a PV guest to bootup if the backend has provided
> > > incorrect values. [*2]
> > 
> > I approve of being liberal in what is accepted but do we also have a
> > handle on why the backend is providing incorrect values in the first
> > place?
> 
> I got those fixed too - was using 'xen_irq_from_gsi' while
> it should have used 'xen_irq_from_pirq'. This was the new mechanism
> to obtain the vector values after .. 2.6.38-rc1 ish.. (as the
> GSI values now have the correct value of zero, and the vector value
> for MSI/MSI-X is written in the PIRQ entry).
> 
> But those patches are in a different branch (devel/xen-pciback-0.3).

Thanks, it may be worth co-referencing the front and backend fixes in
their respective commit messages.

Ian.



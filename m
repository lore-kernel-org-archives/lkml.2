Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1EEPI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:08:26 -0400
Received: from smtp.microsoft.com ([131.107.115.215]:6289 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1EEPIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:08:24 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>,
        "gregkh@suse.de" <gregkh@suse.de>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: Tree for May 4 (hyperv / vmbus)
Thread-Topic: linux-next: Tree for May 4 (hyperv / vmbus)
Thread-Index: AQHMCntDW7pkpEnFr0aGj9XnC6EQgpR+VQGggAB2MgD//4xNwA==
Date: Thu, 5 May 2011 15:08:23 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C562498A58B1@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
	<20110504094908.b8295d22.randy.dunlap@oracle.com>
 <8AFC7968D54FB448A30D8F38F259C562498A5852@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <6E21E5352C11B742B20C142EB499E0481E039F@TK5EX14MBXC124.redmond.corp.microsoft.com>
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481E039F@TK5EX14MBXC124.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Thursday, May 05, 2011 8:02 AM
> To: Hank Janssen; Randy Dunlap; Stephen Rothwell; driverdevel;
> gregkh@suse.de
> Cc: Haiyang Zhang; linux-next@vger.kernel.org; LKML
> Subject: RE: linux-next: Tree for May 4 (hyperv / vmbus)
> > > -----Original Message-----
> > > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > > owner@vger.kernel.org] On Behalf Of Randy Dunlap
> > > Sent: Wednesday, May 04, 2011 9:49 AM
> > > To: Stephen Rothwell; driverdevel; gregkh@suse.de
> > > Cc: linux-next@vger.kernel.org; LKML; Hank Janssen; Haiyang Zhang
> > > Subject: Re: linux-next: Tree for May 4 (hyperv / vmbus)
> > >
> > > On Wed, 4 May 2011 14:47:59 +1000 Stephen Rothwell wrote:
> > >
> > > > Hi all,
> > > >
> > > > Changes since 20110503:
> > >
> > >
> > > when CONFIG_ACPI is not enabled:
> > >
> > >
> > >
> > > vmbus_drv.c sure looks like it requires (depends on) both ACPI and PCI.
> > > That should be expressed somewhere in its Kconfig file.
> > >
> >
> > Randy,
> >
> > Oops, I will submit a patch today to correct it. Thanks for catching it.
> >
> > Hank.
> 
> Hank,
> 
> This patch was submitted yesterday.
> 
> K. Y

Completely missed it :)

Thanks,

Hank.


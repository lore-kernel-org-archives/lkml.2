Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2DWRKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:10:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17591 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2DWRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:10:35 -0400
Date: Mon, 23 Apr 2012 13:05:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH 1/3] Add mcelog support for xen platform
Message-ID: <20120423170507.GD22364@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC8292335154EFC@SHSMSX101.ccr.corp.intel.com>
 <20120421041454.GA29704@phenom.dumpdata.com>
 <20120421104502.GB17005@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F170EF841@ORSMSX104.amr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC8292335168D26@SHSMSX101.ccr.corp.intel.com>
 <4F9582C2.6020009@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F9582C2.6020009@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:26:42AM -0700, H. Peter Anvin wrote:
> On 04/23/2012 08:43 AM, Liu, Jinsong wrote:
> > 
> > and, hypervisor only record error into its mc_info cookie (in its
> > own format), it doesn't care what's dom0's version and how dom0 translate it
> > -- that's dom0's business. The role of hypervisor is virtual 'platform',
> > just like h/w platform don't care what linux version runs over it.
> > 
> 
> And this is the *OTHER* problem with Xen.  A platform is only a platform
> if it is documented.  There are a number of PV hypervisors which *are*
> documented in detail, but Xen is not one of them.

And slowly we are working on that. As I mentioned to you, we are in process
of documenting those calls so that there is a document similar to an SDM.
It takes time though.

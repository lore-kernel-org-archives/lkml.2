Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab2KHBVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 20:21:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40201 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2KHBVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 20:21:53 -0500
Date: Wed, 7 Nov 2012 20:08:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/2] Xen acpi pad implement
Message-ID: <20121108010836.GB21302@phenom.dumpdata.com>
References: <20121102164937.GC27213@konrad-lan.dumpdata.com>
 <alpine.DEB.2.02.1211051512260.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B10C@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC829233537B147@SHSMSX101.ccr.corp.intel.com>
 <alpine.DEB.2.02.1211061455150.2689@kaball.uk.xensource.com>
 <DE8DF0795D48FD4CA783C40EC829233537B479@SHSMSX101.ccr.corp.intel.com>
 <20121106164303.GO9966@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233537B99E@SHSMSX101.ccr.corp.intel.com>
 <20121107160301.GF18615@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233537BB2F@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233537BB2F@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 04:52:50PM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Wed, Nov 07, 2012 at 12:58:19PM +0000, Liu, Jinsong wrote:
> >>>>> 
> >>>>> If it is generic ACPI code, than it can depend only on ACPI.
> >>>>> If it is ACPI code that contains X86 specific info, than it needs
> >>>>> to depend on X86 too.
> >>>> 
> >>>> No x86 specific so let's depend on ACPI.
> >>> 
> >>> Huh? This feature is x86 specific isn't it? I mean it is in the ACPI
> >>> spec, but only x86 does it right?
> >> 
> >> OK, updated w/ ACPI & X86 dependency, and per other comments.
> > 
> > Ok. Could you send all the patchset in one go. I am bit lost of which
> > one to review as none of them seem to have the version information
> > [vX: Did this yyy]
> 
> Not quite clear your meaning, do you mean not reply old email and start a new thread with title like
> [PATCH vX 1/2]: xen/acpi: ACPI PAD driver
> [PATCH vX 2/2]: ...

Have you ever used git-send email? If you repost them all it comes out threaded
and it makes it easy to apply the whole patchset in one go.

> ?
> 
> > 
> > right above your name or in the title:
> > [PATCH vX 1/2]: yyyy
> > 
> > anyhow, some comments below.
> > 
> 
> OK.
> 
> Thanks,
> Jinsong

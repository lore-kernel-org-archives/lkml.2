Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2C1Odf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:33:35 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28617 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab2C1Odc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:33:32 -0400
Date: Wed, 28 Mar 2012 10:27:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jinsong Liu <jinsong.liu@intel.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt
 platform
Message-ID: <20120328142742.GD18161@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <20120324003111.GA11777@andromeda.dapyr.net>
 <DE8DF0795D48FD4CA783C40EC8292335105AAF@SHSMSX101.ccr.corp.intel.com>
 <20120326163558.GC10236@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC829233510CE6F@SHSMSX101.ccr.corp.intel.com>
 <4F732365020000780007B6A1@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F732365020000780007B6A1@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090207.4F7320ED.0084,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 01:42:45PM +0100, Jan Beulich wrote:
> >>> On 28.03.12 at 12:48, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> > But just curious, what's the purpose and benefit of exposing mwait to dom0? 

So that cstate.c can evaluate properly the deeper C-states and xen-acpi-processor
can upload them to the hypervisor.

> > I remember xen against doing so before.
> 
> And I don't recall anything having changed in that regard.

Jan, you Acked the patch in question: https://lkml.org/lkml/2012/2/24/129

> 
> Jan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

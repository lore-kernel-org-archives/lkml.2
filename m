Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab0DHSka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 14:40:30 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:33542 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab0DHSk3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 8 Apr 2010 14:40:29 -0400
Date: Thu, 8 Apr 2010 14:38:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Liang Li <liang.li@windriver.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [LKML] Re: +
	x86-fix-handling-of-the-reservetop-boot-option.patch added to -mm
	tree
Message-ID: <20100408183806.GA30940@phenom.dumpdata.com>
References: <4BBD1AA3.4000204@oracle.com> <20100408010558.GA4053@localhost> <4BBD2DD4.1060101@oracle.com> <20100408015353.GB4053@localhost> <4BBD5BEF.3000406@oracle.com> <20100408045945.GB26543@localhost> <4BBD7E52.80507@oracle.com> <20100408085814.GD26543@localhost> <4BBE0E61.5070401@goop.org> <4BBE1A6A.60500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBE1A6A.60500@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BBE2302.0094:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:03:22AM -0700, Yinghai wrote:
> On 04/08/2010 10:12 AM, Jeremy Fitzhardinge wrote:
> > On 04/08/2010 01:58 AM, Liang Li wrote:
> >>>     
> >> When linux as vmi/xen/lguest guest OS, kernel call reserve_top_address
> >> before start_kernel. It is far before the start_kernel hence far before
> >> setup_arch->early_ioremap_init. So it is unsafe to place
> >> fixup_early_ioremap inside reserve_top_address. So I think the patch
> >> should be:
> >>   
> > 
> > Yes indeed.  That looks better.
> > 
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

I've also tested it today as PV Xen guest:

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

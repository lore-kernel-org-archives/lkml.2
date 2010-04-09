Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab0DIAar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:30:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:57710 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0DIAap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:30:45 -0400
Date: Fri, 9 Apr 2010 08:28:09 +0800
From: Liang Li <liang.li@windriver.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Yinghai <yinghai.lu@oracle.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       wangchen@cn.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [LKML] Re: +
 x86-fix-handling-of-the-reservetop-boot-option.patch added to -mm tree
Message-ID: <20100409002809.GE26543@localhost>
Reply-To: Liang Li <liang.li@windriver.com>
References: <20100408010558.GA4053@localhost>
 <4BBD2DD4.1060101@oracle.com>
 <20100408015353.GB4053@localhost>
 <4BBD5BEF.3000406@oracle.com>
 <20100408045945.GB26543@localhost>
 <4BBD7E52.80507@oracle.com>
 <20100408085814.GD26543@localhost>
 <4BBE0E61.5070401@goop.org>
 <4BBE1A6A.60500@oracle.com>
 <20100408183806.GA30940@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408183806.GA30940@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 09 Apr 2010 00:29:37.0954 (UTC) FILETIME=[BCA7C020:01CAD77B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 02:38:06PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Apr 08, 2010 at 11:03:22AM -0700, Yinghai wrote:
> > On 04/08/2010 10:12 AM, Jeremy Fitzhardinge wrote:
> > > On 04/08/2010 01:58 AM, Liang Li wrote:
> > >>>     
> > >> When linux as vmi/xen/lguest guest OS, kernel call reserve_top_address
> > >> before start_kernel. It is far before the start_kernel hence far before
> > >> setup_arch->early_ioremap_init. So it is unsafe to place
> > >> fixup_early_ioremap inside reserve_top_address. So I think the patch
> > >> should be:
> > >>   
> > > 
> > > Yes indeed.  That looks better.
> > > 
> > > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> I've also tested it today as PV Xen guest:
> 
> Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thanks all. Updated patch will be sent out soon.

Best regards,
	 	-Liang Li

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

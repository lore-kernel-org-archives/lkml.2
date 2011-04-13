Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1DMSEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 14:04:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32416 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1DMSEK (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 13 Apr 2011 14:04:10 -0400
Date: Wed, 13 Apr 2011 14:03:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com
Cc: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, mingo@elte.hu,
        yinghai@kernel.org
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
Message-ID: <20110413180348.GB19390@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
 <4DA48EA9.70109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA48EA9.70109@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DA5E587.0110:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 10:40:57AM -0700, Yinghai Lu wrote:
> On 04/12/2011 04:19 AM, stefano.stabellini@eu.citrix.com wrote:
> >From: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
> >
> >Introduce a new x86_init hook called pagetable_reserve that during the
> >initial memory mapping is used to reserve a range of memory addresses for
> >kernel pagetable usage.
> >
> >On native it just calls memblock_x86_reserve_range while on xen it also
> >takes care of setting the spare memory previously allocated
> >for kernel pagetable pages from RO to RW, so that it can be used for
> >other purposes.
> >
> >Signed-off-by: Stefano Stabellini<stefano.stabellini@eu.citrix.com>
> >Cc: Yinghai Lu<yinghai@kernel.org>
> >Cc: H. Peter Anvin<hpa@zytor.com>
> >Cc: Ingo Molnar<mingo@elte.hu>
> 
> Acked-by: Yinghai Lu <yinghai@kernel.org>

Peter,

I stuck this and some of the other in this thread on 'stable/bug-fixes-rc3'
(git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git). But before
I send them to Linus to pull I need your OK? Would it be OK if I stuck
your Ack on the patch?

Or you could take this patch (the one I stuck in my tree has the description
a bit modified so I recommend that one).

Thanks,
Konrad

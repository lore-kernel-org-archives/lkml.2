Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab1DMUTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 16:19:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43829 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889Ab1DMUTw (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 13 Apr 2011 16:19:52 -0400
Date: Wed, 13 Apr 2011 16:19:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, jeremy@goop.org, mingo@elte.hu,
        yinghai@kernel.org
Subject: Re: [PATCH 2/4] x86,xen: introduce
 x86_init.mapping.pagetable_reserve
Message-ID: <20110413201929.GA21077@dumpdata.com>
References: <alpine.DEB.2.00.1104121149280.22672@kaball-desktop>
 <1302607192-21355-2-git-send-email-stefano.stabellini@eu.citrix.com>
 <4DA48EA9.70109@kernel.org>
 <20110413180348.GB19390@dumpdata.com>
 <4DA5ECD6.3000409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5ECD6.3000409@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA60555.00D7:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 11:35:02AM -0700, H. Peter Anvin wrote:
> On 04/13/2011 11:03 AM, Konrad Rzeszutek Wilk wrote:
> > 
> > Peter,
> > 
> > I stuck this and some of the other in this thread on 'stable/bug-fixes-rc3'
> > (git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git). But before
> > I send them to Linus to pull I need your OK? Would it be OK if I stuck
> > your Ack on the patch?
> > 
> > Or you could take this patch (the one I stuck in my tree has the description
> > a bit modified so I recommend that one).
> > 
> 
> You have my extremely firm NAK until the intended semantics of the new
> hook is explained in detail.

<nods>I will let Stefano answer your questions as he has been battling
this particular regression and trying to find an acceptable solution
to the problem.

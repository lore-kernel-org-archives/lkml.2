Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0CSTey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 15:34:54 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11766 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0CSTex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 15:34:53 -0400
X-IronPort-AV: E=Sophos;i="4.51,276,1267419600"; 
   d="scan'208";a="7629189"
Subject: Re: Infinite loop on boot in free_early_partial due to start==end
 on tip/master
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4BA3CAB8.7000702@kernel.org>
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
	 <20100319182807.GA14985@phenom.dumpdata.com>  <4BA3CAB8.7000702@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Fri, 19 Mar 2010 19:34:49 +0000
Message-ID: <1269027289.23584.0.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-19 at 19:04 +0000, Yinghai Lu wrote: 
> On 03/19/2010 11:28 AM, Konrad Rzeszutek Wilk wrote:
> >> Subject: x86: do not free zero sized per cpu areas
> >>
> >> This avoids an infinite loop in free_early_partial().
> > 
> > The patch fixed PV guests booting on Xen. I've added my
> > Tested-by .. Please merge it in the release.
> > 
> > Thanks!
> >>
> >> Add a warning to free_early_partial to catch future problems.
> >>
> >> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> please check update version...
> 
> please check if this patch help...
> 
> http://patchwork.kernel.org/patch/83832/

Sorry Konrad, looks like I directed you to an older version of the patch
by mistake.

Ian.



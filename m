Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2F1MpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:45:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:5586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2F1MpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="116927892"
Date: Thu, 28 Jun 2012 14:56:12 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Dave Jones <davej@redhat.com>,
        David Miller <davem@davemloft.net>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] net: nfc: fix panic in accept()
Message-ID: <20120628125612.GG4846@sortiz-mobl>
References: <1339425693.6001.2268.camel@edumazet-glaptop>
 <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop>
 <20120611152007.GZ22557@sortiz-mobl>
 <1339433810.4999.65.camel@lappy>
 <20120611172545.GA1776@redhat.com>
 <CA+1xoqcwr-5dzHvqkt9x0-xj9EFAywVfva=asbHXvX-LSBWqdA@mail.gmail.com>
 <1340639612.10893.84.camel@edumazet-glaptop>
 <20120625171532.GB16275@sortiz-mobl>
 <CA+1xoqfy21wOh2myV0D6iBDqoZ3YmkwNZwKBVXLU75zePOGi4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqfy21wOh2myV0D6iBDqoZ3YmkwNZwKBVXLU75zePOGi4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Thu, Jun 28, 2012 at 02:11:38PM +0200, Sasha Levin wrote:
> Hi Samuel,
> 
> On Mon, Jun 25, 2012 at 7:15 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > Hi Eric,
> >
> > On Mon, Jun 25, 2012 at 05:53:32PM +0200, Eric Dumazet wrote:
> >> From: Eric Dumazet <edumazet@google.com>
> >>
> >> Sasha Levin reported following panic :
> > I applied a similar patch, more consistent with the rest of the NFC socket
> > code, still with you as the author. See here:
> >
> > http://git.kernel.org/?p=linux/kernel/git/sameo/nfc-3.0.git;a=commit;h=631c301f20558525a641fadffc0126affd3dc4a4
> 
> Could this tree be included in -next please?
No, wireless-next is already included in -next. The above patch is making its
way upstream, it's in the wireless.git tree and should hit davem's net tree
soon.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

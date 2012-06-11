Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab2FKPJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:09:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:50591 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab2FKPJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:09:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164193611"
Date: Mon, 11 Jun 2012 17:20:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, David Miller <davem@davemloft.net>,
        lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: net: nfc: BUG and panic in accept() on 3.5-rc2
Message-ID: <20120611152007.GZ22557@sortiz-mobl>
References: <1339423241.4999.53.camel@lappy>
 <20120611144134.GX22557@sortiz-mobl>
 <1339425693.6001.2268.camel@edumazet-glaptop>
 <20120611145700.GY22557@sortiz-mobl>
 <1339426778.6001.2312.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339426778.6001.2312.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:59:38PM +0200, Eric Dumazet wrote:
> On Mon, 2012-06-11 at 16:57 +0200, Samuel Ortiz wrote:
> > Hi Eric,
> > 
> > On Mon, Jun 11, 2012 at 04:41:33PM +0200, Eric Dumazet wrote:
> > > On Mon, 2012-06-11 at 16:41 +0200, Samuel Ortiz wrote:
> > > > Hi Sasha,
> > > > 
> > > > On Mon, Jun 11, 2012 at 04:00:41PM +0200, Sasha Levin wrote:
> > > > > Hi all,
> > > > > 
> > > > > I've stumbled on the following while fuzzing with trinity inside a KVM tools guest, running on 3.5-rc2:
> > > > > 
> > > > Thanks for the report, it could be worth adding this one to
> > > > bugzilla.kernel.org.
> > > > 
> > > > What's trinity ?
> > > > Also, if this one is reproducible, would you mind sharing some details about
> > > > how we could reproduce it ?
> > > 
> > > Well, bugfix should be trivial enough ;)
> > Yep, I looked at the code only after looking at Sasha's report.
> > 
> > Thanks for the patch, do you mind if I add your SOB to it ?
> 
> I would prefer making sure it fixes the bug first ;)
Sure, although your patch makes sense regardless of that :)
I'll still wait for Sasha to confirm that it fixes his crash.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

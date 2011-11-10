Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1KJC4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:56:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:23717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab1KJC43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:56:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,486,1315206000"; 
   d="scan'208";a="88331372"
Subject: Re: Staging clear up
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20111109232533.16780313@lxorguk.ukuu.org.uk>
References: <20111109121329.GC21630@sirena.org.uk>
	 <1320854413.32205.948.camel@vkoul-udesk3>
	 <20111109164211.GA4016@opensource.wolfsonmicro.com>
	 <20111109165518.GA13451@kroah.com>
	 <20111109165829.GC4016@opensource.wolfsonmicro.com>
	 <20111109173037.66bea268@lxorguk.ukuu.org.uk>
	 <20111109225933.GA17769@opensource.wolfsonmicro.com>
	 <20111109230318.1168fd9e@lxorguk.ukuu.org.uk>
	 <20111109230329.GB17769@opensource.wolfsonmicro.com>
	 <20111109230558.2fb94c0b@lxorguk.ukuu.org.uk>
	 <20111109231124.GC17769@opensource.wolfsonmicro.com>
	 <20111109232533.16780313@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 08:22:01 +0530
Message-ID: <1320893521.32205.1196.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 23:25 +0000, Alan Cox wrote:
> On Wed, 9 Nov 2011 23:11:24 +0000
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Wed, Nov 09, 2011 at 11:05:58PM +0000, Alan Cox wrote:
> > 
> > > Yes - then it doesn't compile. The codec is calling functions defined in
> > > that header. I don't think you need much of it but both bits of that
> > > driver are using some of the stuff.
> > 
> > Oh, actually the mainline CODEC driver doesn't have any such staging
> > references in it at all.  I don't know what tree you're patching
> > against?
> 
> Sorry I did the patches against the tree I had handy, that had some other
> SoC audio bits in it so ignore them.
The codec does not call any sst bits in upstream tree.
Only platform driver has that dependency.

I plan to rework this interface this month and fix it much before 3.3 :)

If you guys agree we can live with non compiling driver for little
while, otherwise we can use Alans fixes.

Thanks
-- 
~Vinod


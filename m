Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab0LILth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 06:49:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:21954 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab0LILtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 06:49:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="866302098"
Date: Thu, 9 Dec 2010 12:49:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cs5535-mfd: fix warning on x86-64
Message-ID: <20101209114932.GB8884@sortiz-mobl>
References: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
 <20101129204410.339805ef@queued.net>
 <20101130100137.GA11125@sortiz-mobl>
 <20101207103806.74cc9f48@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101207103806.74cc9f48@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Tue, Dec 07, 2010 at 10:38:06AM -0800, Andres Salomon wrote:
> On Tue, 30 Nov 2010 11:01:38 +0100
> Samuel Ortiz <sameo@linux.intel.com> wrote:
> 
> > Hi Andres,
> > 
> > On Mon, Nov 29, 2010 at 08:44:10PM -0800, Andres Salomon wrote:
> > > On Mon, 29 Nov 2010 11:52:57 +1100
> > > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > 
> > > > Hi Samuel,
> > > > 
> > > > After merging the mfd tree, today's linux-next build (x86_64
> > > > allmodconfig) produced this warning:
> > > > 
> > > > drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
> > > > drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type
> > > > 'int', but argument 3 has type 'long unsigned int'
> > > > 
> > > 
> > > Ick, ARRAY_SIZE is unsigned int on x86, unsigned long on x86-64.
> > > The patch below fixes this.
> > > 
> > > 
> > > 
> > > 
> > > From: Andres Salomon <dilinger@queued.net>
> > > 
> > > ARRAY_SIZE() returns unsigned long on x86-64 (rather than unsigned
> > > int); cast it to the desired type to shut gcc up.
> > Patch applied, many thanks.
> > I'll look at your subdevices patches by the end of this week.
> > 
> 
> Did you get the chance to look at them?  Also, note that there's an
> updated patch for the cs5535-mfd warnings (v2, acked by Randy).

Yes, I've taken this one, along with the gpio and misc subdevices drivers.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

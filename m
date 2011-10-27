Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1J0IlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:41:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:51133 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab1J0IlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:41:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,412,1315206000"; 
   d="scan'208";a="82978250"
Subject: Re: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Barry Song <Barry.Song@csr.com>, Arnd Bergmann <arnd@arndb.de>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <Rongjun.Ying@csr.com>,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20111027083318.GC19187@n2100.arm.linux.org.uk>
References: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
	 <1319703535.20054.30.camel@vkoul-udesk3>
	 <20111027083318.GC19187@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 14:08:09 +0530
Message-ID: <1319704689.20054.37.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 09:33 +0100, Russell King - ARM Linux wrote:
> On Thu, Oct 27, 2011 at 01:48:55PM +0530, Vinod Koul wrote:
> > On Mon, 2011-10-17 at 20:08 -0700, Barry Song wrote:
> > > From: Rongjun Ying <Rongjun.Ying@csr.com>
> > > 
> > > Cc: Jassi Brar <jaswinder.singh@linaro.org>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > > Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> > > Signed-off-by: Barry Song <Baohua.Song@csr.com>
> > > ---
> > >  -v4:
> > >  add error handler in probe;
> > >  free resource in remove;
> > >  add necessary comments in source codes;
> > >  fix the mismatch of license between file head and MODULE_LINCENSE;
> > >  define MACRO to replace magic number for xlen/dma_width boundary.
> > Barry,
> > 
> > You should _always_ run checkpatch before sending patches. It should
> > have 0 errors.
> 
> Not true. 
> 
> > ERROR: trailing whitespace
> > #773: FILE: drivers/dma/sirf-dma.c:649:
> > +^I$
> > 
> > 
> > Also there are bunch of 80char warning, see if you can reduce/eliminate
> > them without sacrificing the code readability, and looking at them it
> > seems possible
> 
> 80char warnings about printks should be ignored, because breaking kernel
> messages across lines prevents them from being greppable.  This (breaking
> kernel messages, particularly error messages, across multiple lines) is a
> topic Linus has frequently complained about.
Sure, I wasn't complaining about printks, btw none of them were hit by
printks.

These were mostly write_l exceeding 80chars, thats why my suggestion to
see if they can be reduced/eliminated without sacrificing code
readability


-- 
~Vinod


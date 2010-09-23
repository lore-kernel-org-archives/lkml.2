Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0IWK1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 06:27:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40022 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751039Ab0IWK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 06:27:10 -0400
Date: Thu, 23 Sep 2010 11:27:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Grant Likely <grant.likely@secretlab.ca>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923102708.GC25663@rakim.wolfsonmicro.main>
References: <20100920140049.31408.67527.stgit@localhost.localdomain>
 <20100920150431.GD31167@sirena.org.uk>
 <20100920152726.68ac2d84@linux.intel.com>
 <20100920152705.GJ3414@rakim.wolfsonmicro.main>
 <AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
 <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
 <20100923095411.GA25663@rakim.wolfsonmicro.main>
 <20100923112703.543b0b86@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923112703.543b0b86@lxorguk.ukuu.org.uk>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:27:03AM +0100, Alan Cox wrote:

> > To be honest I'd actually be inclined to go more towards the way the
> > non-DT embedded platforms have gone and just ignore the data we get
> > from SFI as much as possible and have board specific initialisation in
> > code; it's boring and repetitive but it's also clear and *relatively*
> > robust.

> And even more unmaintainable. Won't happen.

So what is the plan for coping with OEM systems?  Right now the code
makes no provision at all that I can see for system-specific handling
of the SFI data which seems very optimistic.

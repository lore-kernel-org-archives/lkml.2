Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab0IWOqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:46:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34140 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753740Ab0IWOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:46:09 -0400
Date: Thu, 23 Sep 2010 15:46:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923144606.GH25663@rakim.wolfsonmicro.main>
References: <20100922231514.5e9967c7@linux.intel.com>
 <20100923060703.GB11198@angua.secretlab.ca>
 <20100923095411.GA25663@rakim.wolfsonmicro.main>
 <20100923112703.543b0b86@lxorguk.ukuu.org.uk>
 <20100923102708.GC25663@rakim.wolfsonmicro.main>
 <20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
 <20100923105208.GD25663@rakim.wolfsonmicro.main>
 <20100923111347.0cf93bb3@linux.intel.com>
 <20100923141133.GG25663@rakim.wolfsonmicro.main>
 <20100923142720.13bf9d69@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923142720.13bf9d69@linux.intel.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 02:27:20PM +0100, Alan Cox wrote:

> > What is it about this platform that is going to restrict the problem?

> The sort of people who will be using it and how,

Can you be more specific?  This is the same sort of thing people
normally say but the experience is that it rarely survives a successful
product.

> > Code which makes this sort of assumption about knowing the platforms
> > that the device will be deployed on well is relatively common but the
> > usual result is that OEMs want to change the reference platforms and
> > the assumptions that the code has been making about the systems and
> > about how people will work with the code break down.

> There are non reference platforms in existence without the problem you
> envisage having occurred. So I think we'll worry about it if it happens
> but knowing that with DMI we have the tools to deal with this.

It doesn't break down immediately; a combination of volume and the next
generation product coming along and grabbing attention is usually what
causes things to break down.  However, if you're totally confident that
all the BIOS authors at the OEMs are going to work well together here
then I guess it's only Moorestown that's affected.

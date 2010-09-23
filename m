Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0IWOO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:14:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:48139 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407Ab0IWOOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:14:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,223,1283756400"; 
   d="scan'208";a="327899717"
Date: Thu, 23 Sep 2010 14:27:20 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923142720.13bf9d69@linux.intel.com>
In-Reply-To: <20100923141133.GG25663@rakim.wolfsonmicro.main>
References: <20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	<20100922231514.5e9967c7@linux.intel.com>
	<20100923060703.GB11198@angua.secretlab.ca>
	<20100923095411.GA25663@rakim.wolfsonmicro.main>
	<20100923112703.543b0b86@lxorguk.ukuu.org.uk>
	<20100923102708.GC25663@rakim.wolfsonmicro.main>
	<20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
	<20100923105208.GD25663@rakim.wolfsonmicro.main>
	<20100923111347.0cf93bb3@linux.intel.com>
	<20100923141133.GG25663@rakim.wolfsonmicro.main>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There should be no variations and the nature of the platform means
> > that might even work out. I don't really want to add it to the
> > table unless we have lots needing DMI data. Right now we don't and
> > there are multiple platform implementations in existence.
> 
> What is it about this platform that is going to restrict the problem?

The sort of people who will be using it and how,

> Code which makes this sort of assumption about knowing the platforms
> that the device will be deployed on well is relatively common but the
> usual result is that OEMs want to change the reference platforms and
> the assumptions that the code has been making about the systems and
> about how people will work with the code break down.

There are non reference platforms in existence without the problem you
envisage having occurred. So I think we'll worry about it if it happens
but knowing that with DMI we have the tools to deal with this.

Alan

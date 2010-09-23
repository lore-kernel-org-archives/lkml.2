Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0IWLAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:00:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:21891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab0IWLAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:00:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,222,1283756400"; 
   d="scan'208";a="327839660"
Date: Thu, 23 Sep 2010 11:13:47 +0100
From: Alan Cox <alan@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        x86@kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/mrst: add SFI platform device parsing code
Message-ID: <20100923111347.0cf93bb3@linux.intel.com>
In-Reply-To: <20100923105208.GD25663@rakim.wolfsonmicro.main>
References: <20100920150431.GD31167@sirena.org.uk>
	<20100920152726.68ac2d84@linux.intel.com>
	<20100920152705.GJ3414@rakim.wolfsonmicro.main>
	<AANLkTi=1dkVOWc2WHhYgqKh_awUhp1-uKN8W7Xx3AB_X@mail.gmail.com>
	<20100922231514.5e9967c7@linux.intel.com>
	<20100923060703.GB11198@angua.secretlab.ca>
	<20100923095411.GA25663@rakim.wolfsonmicro.main>
	<20100923112703.543b0b86@lxorguk.ukuu.org.uk>
	<20100923102708.GC25663@rakim.wolfsonmicro.main>
	<20100923115818.0cac8d06@lxorguk.ukuu.org.uk>
	<20100923105208.GD25663@rakim.wolfsonmicro.main>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the expectation is that the platform data parser functions in the
> SFI device list will be querying the DMI data and selecting the actual
> parsing based on that?  Perhaps adding DMI keys to the match tables so
> the infrastructure is there for doing the device specific things would
> cover it; minor differences could be worked out in the default match
> function and we can drop back to board specific functions when it gets
> too messy.

That will just encourage people not to be careful.

> My main issue here is that the code is working on the assumption that
> we have one standard idea of what the SFI data means and provides no
> guidance to users about handling the inevitable variations.

There should be no variations and the nature of the platform means that
might even work out. I don't really want to add it to the table unless
we have lots needing DMI data. Right now we don't and there are
multiple platform implementations in existence.

Alan

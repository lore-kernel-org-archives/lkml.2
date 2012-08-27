Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2H0FnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 01:43:12 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5903 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2H0FnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 01:43:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 26 Aug 2012 22:43:10 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>
CC: "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Mon, 27 Aug 2012 13:43:07 +0800
Subject: RE: Shutdown problem in SMP system happened on Tegra20
Thread-Topic: Shutdown problem in SMP system happened on Tegra20
Thread-Index: Ac2CkcVRY3F5RuuoRrqO9o4pYoZICABhOcwQ
Message-ID: <A7051F87A141B744BCAF487D48E5B3BDF5BA98284F@HKMAIL02.nvidia.com>
References: <A7051F87A141B744BCAF487D48E5B3BDF5BA982848@HKMAIL02.nvidia.com>
 <20120824182133.GB18957@n2100.arm.linux.org.uk>
 <A7051F87A141B744BCAF487D48E5B3BDF5BA98284A@HKMAIL02.nvidia.com>
 <20120825071755.GG18957@n2100.arm.linux.org.uk>
In-Reply-To: <20120825071755.GG18957@n2100.arm.linux.org.uk>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Aug 25, 2012 at 08:00:56AM +0800, Bill Huang wrote:
> > nvpublic
> > > So what you're asking for is a feature to do what
> > > CONFIG_PM_SLEEP_SMP does, but without CONFIG_PM_SLEEP_SMP enabled?
> >
> > Yeah pretty much, I'm actually asking should we take care of this
> > since maybe not all platforms will have this config enabled?
> > >
> > > Why not just ensure that CONFIG_PM_SLEEP_SMP is enabled if your
> > > platform requires that the lowest CPU number be the CPU dealing with reboot?
> >
> > Someday we will have it enabled, but before that we'll hit the issue,
> > so you don't think this should be taken care of? Thanks.
> 
> Well, just enable CONFIG_PM_SLEEP_SMP then - it'll be far better than trying to implement something in
> the ARM code, especially as sysrq can be used for poweroff/reboot etc (which will run from atomic
> contexts where you can't switch to another CPU.)
> 
> What you're asking for will make these callbacks fragile for other platforms.

OK, thanks.

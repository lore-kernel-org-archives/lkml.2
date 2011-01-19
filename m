Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1ASRmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:42:44 -0500
Received: from void.printf.net ([89.145.121.20]:51162 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753040Ab1ASRmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:42:42 -0500
Date: Wed, 19 Jan 2011 17:42:33 +0000
From: Chris Ball <cjb@laptop.org>
To: Philip Rakity <prakity@marvell.com>
Cc: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        Kyungmin Park <kmpark@infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew.chih.howe.khor@intel.com" <andrew.chih.howe.khor@intel.com>,
        "kok.howg.ewe@intel.com" <kok.howg.ewe@intel.com>
Subject: Re: A MMC card transfer issue
Message-ID: <20110119174233.GA30494@void.printf.net>
References: <4CD8DE9C.4040505@dsn.okisemi.com> <AANLkTimfnj8GcSwmALjaZUBsiq6ssaVuzVZZsZHRYmiX@mail.gmail.com> <001701cb814c$71926bf0$66f8800a@maildom.okisemi.com> <001201cb90f4$4be8f790$66f8800a@maildom.okisemi.com> <2D50F985-2383-4406-8514-DFE462A5F546@marvell.com> <4D2E0464ABB54FFF9C10583336E27879@hacdom.okisemi.com> <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4E7DE5-7CF1-4D97-9CAD-F600FCBE477A@marvell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 18, 2011 at 10:05:04PM -0800, Philip Rakity wrote:
> 
> For 1 bit transcend cards you need these 2 patches.
> 
> >From 22113efd00491310da802f3b1a9a66cfcf415fac Mon Sep 17 00:00:00 2001
> From: Aries Lee <arieslee@jmicron.com>
> Date: Wed, 15 Dec 2010 08:14:24 +0100
> Subject: [PATCH] mmc: Test bus-width for old MMC devices

Present in 2.6.38-rc1.

> >From 08c82dfad2458f8f9b83126224a85e7ea9e2b046 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 22 Dec 2010 09:59:44 +0100
> Subject: [PATCH] mmc: fix mmc_set_bus_width_ddr() call without bus-width-test cap

Also present in 2.6.38-rc1.

So, please re-test against 2.6.38-rc1 and let us know whether you still
have problems.  Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child

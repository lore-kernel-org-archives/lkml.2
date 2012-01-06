Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab2AFLT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:19:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10222 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab2AFLTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:19:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 06 Jan 2012 03:19:55 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Fri, 6 Jan 2012 16:49:50 +0530
Subject: RE: [PATCH V1] regulator: fixed: Move drivers to
 subsys_initcall_sync()
Thread-Topic: [PATCH V1] regulator: fixed: Move drivers to
 subsys_initcall_sync()
Thread-Index: AczMP+wsl1U56AeBS4+K9Du1X8LgWAAJKiXQ
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA01F@BGMAIL01.nvidia.com>
References: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
 <20120105055900.GE11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9DEC@BGMAIL01.nvidia.com>
 <20120106065329.GC3496@opensource.wolfsonmicro.com>
In-Reply-To: <20120106065329.GC3496@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-owner@vger.kernel.org]
> On Behalf Of Mark Brown
> Sent: Friday, January 06, 2012 12:24 PM

> > is in subsys_initcall_sync() in place of arch_init, although driver is in
> > subsys_initcall() to postponed the probe calling.
> 
> > What do you suggest on this case?
> 
> Honestly I'd suggest that you contribute to the effort to get the probe
> ordering handling code implemented in mainline.  This just seems like a
> big can of worms to open up for something that's hopefully just going to
> be a short term thing.  It's a real problem but this seems fairly niche
> and like if we start doing more than we're already doing we're going to
> end up running around chasing our own tails on this stuff.  I'm really
> not sure what the status is on that work, though - it may be that you
> actually need to pick the patches up and push them forwards yourself.

Completely agree with you. I went through the Grant's change 
" drivercore: Add driver probe deferral mechanism" and it is
discussed in more details here. I will start different thread
communication on this issue.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

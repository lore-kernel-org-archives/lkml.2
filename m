Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2AEONm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:13:42 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12763 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2AEONk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:13:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jan 2012 06:13:39 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan.com@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 5 Jan 2012 19:42:10 +0530
Subject: RE: [PATCH] regulator: Rail is said to be enable only if this and
	supply rails are enabled.
Thread-Topic: [PATCH] regulator: Rail is said to be enable only if this and
	supply rails are enabled.
Thread-Index: AczLcDnwbmwZOHCPTbOZr33IHpo0xwAQ5Wkg
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9EA9@BGMAIL01.nvidia.com>
References: <1325570983-3700-1-git-send-email-ldewangan@nvidia.com>
 <20120103201624.GC2843@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9C2E@BGMAIL01.nvidia.com>
 <20120105060646.GG11867@opensource.wolfsonmicro.com>
In-Reply-To: <20120105060646.GG11867@opensource.wolfsonmicro.com>
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

> From: linux-tegra-owner@vger.kernel.org [mailto:linux-tegra-
> owner@vger.kernel.org] On Behalf Of Mark Brown
> Sent: Thursday, January 05, 2012 11:37 AM


> > returns true but actually the rail is not enabled because supply rail was
> not enabled.
> > Although it is fixed in other patch but such checks help more.
> 
> You're not quite getting my point here - we should be treating this as
> an error and complaining about it when we notice it, your patch will
> silently mask the condition which seems likely to just cause the bug to
> manifest elsewhere.

Agree with you. Thanks for such details.

Thanks,
Laxman

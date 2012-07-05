Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab2GEOIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:08:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab2GEOIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:08:37 -0400
Date: Thu, 5 Jul 2012 16:08:31 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v2] ASoC: siu: don't use DMA device for channel
 filtering
In-Reply-To: <20120705140053.GL4111@opensource.wolfsonmicro.com>
Message-ID: <Pine.LNX.4.64.1207051608160.30191@axis700.grange>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
 <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
 <20120705120826.GU4111@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1207051549010.30191@axis700.grange>
 <20120705140053.GL4111@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:IEnHBaIhvKrtEJWZdsOu5qFP2CuPqHwLRMfntcBGtXD
 zuQJLe6pJgWrcoQLqf3xMP0+XXsmC52gHEihgXRScoAWkm+kOD
 1b3FNRPNAgNSR+KKKvKpYlAHF/+04dQxNBxlaQ8fO4M6Z2JoCa
 FH2eX1qJ8+usFwLmcA+cVVKCvhNTwq3FqOpyy8d5kedwKJmliz
 TOuobOo7WmhFBtI7vYukkMRUsJgiHpTZqD82ebKZ2a9IcvaIzW
 nKFsBDl+dn9pAMdqwfEx2bKHaTFJwv2od22pfiswd9ARRrX7MS
 iJ9ISIV340r9YSMBFLsKtpHGZV8Rcf05AdPp3YVhm7XSHYhXd1
 c9DdrkH92nrwpf4z7rLH7eNgRkbITxzhagWNZuEuF4feqIVne4
 BYwWIHOO9V14w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012, Mark Brown wrote:

> On Thu, Jul 05, 2012 at 03:54:30PM +0200, Guennadi Liakhovetski wrote:
> > On Thu, 5 Jul 2012, Mark Brown wrote:
> 
> > > This doesn't apply, please regenerate against current code.
> 
> > Sure, as I mentioned in my description mail: "This patch series goes on 
> > top of my earlier patches to split shdma.c." And that patch series, also 
> > available at
> 
> Ah, right.  You didn't send me your cover mail, you only CCed me on the
> individual patch, so I hadn't seen this.

Indeed, sorry again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab1ITVCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:02:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1ITVCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:02:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
Date: Tue, 20 Sep 2011 23:01:56 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@nvidia.com>, nicolas.pitre@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com> <20110920180731.GL7781@ponder.secretlab.ca> <201109202134.50242.arnd@arndb.de>
In-Reply-To: <201109202134.50242.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109202301.56983.arnd@arndb.de>
X-Provags-ID: V02:K0:OGcZmuAIw6u/a1caWpPYOhqE8CH3GVk0h7M5Gkzlgr0
 ZWETfjHY08pz3RMsr04lPQtWUaBf74Dc4nMZKdFqqDR8ryZhdL
 iQ62g592ebvbkMZQ7KB++TO8aV+nfKLahd2Tjyito52KjCVkfB
 t2dIDZv5e9sWwTzkggjFW4mhgZ3mwYL7jIb0ykDbkhHXx5YUwu
 fokSj83WMp3/seW0rv4SS3n3krArIaIMb5gXDiK2aqDObrJgPU
 sCoFGbv8/sQiSjtCNindVfG1OrUL5gyAE1IakPE2WPdgA23v5n
 CN8eUPAQpwIXE1FPcmesq2k6hi6+AaKmVqCKK1+pUd6rh55E3m
 hDi4ja55t7o4wuXfLvs8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011, Arnd Bergmann wrote:
> On Tuesday 20 September 2011, Grant Likely wrote:
> > On Tue, Sep 20, 2011 at 07:43:29PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 20 September 2011, Stephen Warren wrote:
> > > > The bindings were recently updated to have separate properties for each
> > > > type of GPIO. Update the Device Tree source to match that.
> > > > 
> > > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > > > Acked-by: Olof Johansson <olof@lixom.net>
> > > > ---
> > > > I'd previously sent these to Grant assuming they'd go in his dt/next branch,
> > > > but perhaps these should go in through Arnd's arm-soc next/dt branch?
> > > > 
> > > 
> > > Which tree has the update that changed the bindings? I think it should
> > > go into the same one.
> > > 
> > > If it's already upstream, I can take it into the fixes branch.
> > 
> > Already upstream
> 
> Ok, I see. I've applied both patches to the fixes branch and will send
> it out with the next pull request for 3.1 to Linus then.

Sorry, I just noticed that the second patch is not a bug fix, so I took it out
again and kept only patch 1/2 in the fixes branch for 3.1.

Should I take the other one as well? It's probably better to let that
go the proper way through the tegra tree for 3.2, right?

	Arnd

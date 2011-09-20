Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751010Ab1ITTfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 15:35:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50979 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITTfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 15:35:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
Date: Tue, 20 Sep 2011 21:34:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@nvidia.com>, nicolas.pitre@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com> <201109201943.29510.arnd@arndb.de> <20110920180731.GL7781@ponder.secretlab.ca>
In-Reply-To: <20110920180731.GL7781@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109202134.50242.arnd@arndb.de>
X-Provags-ID: V02:K0:Yq3scPaQd9TNdQIAfojMJCx5L/EuQh2t/yyX9o4DD1Q
 n8F788GIs828dSRAzAxedXBkz9dhLuLMt2dbqhB919xUk0PY19
 1VIxdJi8KGJzexEoA0jRO6ZT6cnMAUgL8tUJnzoGHy69CMenK5
 r+PPb8LeWWKbpLHibKpl2/JddS4+7ky0oBh7VFUmR9n0dTwpsD
 NYRStpiWsr3rJDWaWdxQisoav5tvDfsFAVqAIeEau+roiwmcOx
 SJwVC7NADBjtoAHavi2eIumh2+qcWf0ZX0eAIWukobvdX+XFJT
 9+kEQkEn3O0hw6CCb9StaHXOaTRSlHuktfqiTY9X1iUwkxYBGF
 ATuxiwMEy/fSLfLlKPdU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011, Grant Likely wrote:
> On Tue, Sep 20, 2011 at 07:43:29PM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 September 2011, Stephen Warren wrote:
> > > The bindings were recently updated to have separate properties for each
> > > type of GPIO. Update the Device Tree source to match that.
> > > 
> > > Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > > Acked-by: Olof Johansson <olof@lixom.net>
> > > ---
> > > I'd previously sent these to Grant assuming they'd go in his dt/next branch,
> > > but perhaps these should go in through Arnd's arm-soc next/dt branch?
> > > 
> > 
> > Which tree has the update that changed the bindings? I think it should
> > go into the same one.
> > 
> > If it's already upstream, I can take it into the fixes branch.
> 
> Already upstream

Ok, I see. I've applied both patches to the fixes branch and will send
it out with the next pull request for 3.1 to Linus then.

Thanks,

	Arnd

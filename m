Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1ITRnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 13:43:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64675 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ITRnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 13:43:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
Date: Tue, 20 Sep 2011 19:43:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, nicolas.pitre@linaro.org,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1316537186-26753-1-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109201943.29510.arnd@arndb.de>
X-Provags-ID: V02:K0:3G8U9NXS10v01h5rwKtHM8DWefk7N8YxWZje/1zhKuT
 zhV1YMAPGmaxJf+4NO878G3/n6av5tmmpXQx+KJTSmhMAaKRZ/
 FXQ/AXbyV34wyuV5+iQAWvli2+Jb+5iQahkfed5VgCwU6zdxz3
 aVedciTbK4yQZ62NFrVJ4yxbTiqJWheDettONDHh2es9JV9fHY
 zX8G+k6wBnOskV+p+jtTQlsAMYmd9TKjrBV9ZrzvFpyTKny/PC
 ZTrYuKk3qu5TwPa2Rmt410eZTJu4rXLZDkBHa9LR9luDNpOY7m
 aPIUdGHYcfX4dTpnqsAhGTKa8U7Ey4SvVIUf70q7i0Dw+z+1i9
 PG6xwBivPThyyYpjSoNE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011, Stephen Warren wrote:
> The bindings were recently updated to have separate properties for each
> type of GPIO. Update the Device Tree source to match that.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Olof Johansson <olof@lixom.net>
> ---
> I'd previously sent these to Grant assuming they'd go in his dt/next branch,
> but perhaps these should go in through Arnd's arm-soc next/dt branch?
> 

Which tree has the update that changed the bindings? I think it should
go into the same one.

If it's already upstream, I can take it into the fixes branch.

	Arnd

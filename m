Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1K3NbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:31:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab1K3NbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:31:21 -0500
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/2] pinctrl: make it possible to add multiple maps
Date: Wed, 30 Nov 2011 13:30:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1322656381-6496-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1322656381-6496-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111301330.52801.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:JdOH+b8sjMesTOtCKgjSOC4YQj6Ob1+KZUM+QTdGU9t
 4ew0fA47TVC3DDQGhfZA22+yeFfULa84cvzXVfaLK+f63gS7+M
 zIars7a5Y4FWzDrIalI99vOHIrXivUrHVwxG+Qec7iemgZD3er
 ElbifuzisGyJsAeE8oEO6dJrdwaobqqeuPBnqT5yRUFxajIbVI
 1QKWKZnfoP3UEC11yM+005+8d+TuqfUPu6Jj7iNhAyAWglWaX2
 dcyindDE4LS2HTxRH8O9Ya/TKg7x09ABtcpGC1ahEIt3KWPuAc
 R719OW91G4KuZYizxpl2PcBNDsR/lWoBMzR2MYb8qCN969sd/8
 NNtwpBh7XWF5GroVxFqHUG2N5EwGqIvL12QsqjuMr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 November 2011, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Since we now anyway make a copy of the platform-supplied pinmux
> map, we can just as well make it possible to call the function
> adding maps several times, so as to simplify cases (as PXA) where
> several sets of disparate mappings need to be added depending on
> target platform.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Arnd Bergmann <arnd@linaro.org>

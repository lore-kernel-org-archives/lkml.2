Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1ITXuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 19:50:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59704 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1ITXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 19:50:36 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1316536921.31295.6.camel@vkoul-udesk3>
References: <1314688104.23734.1.camel@phoenix> <1315228918.26251.78.camel@vkoul-udesk3>
 <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
 <1315233379.26251.152.camel@vkoul-udesk3> <CAF+7xWnQAT+rLTz0tj3j1KyUO4Zq-+V=ggHAJVMROXGWp5FA+w@mail.gmail.com>
 <1316536921.31295.6.camel@vkoul-udesk3>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 21 Sep 2011 07:50:15 +0800
Message-ID: <CAF+7xWnkzfX7kWy5K-cHExkYZ-FS8zPXZsjqr2Gu1becbDvRyA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of linux/module.h
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you pls send me your .config?
I got the error by "make imx_v4_v5_defconfig; make"

It's available in arch/arm/configs/imx_v4_v5_defconfig.

> --
> ~Vinod
>
>

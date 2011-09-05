Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1IENdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:33:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45333 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab1IENdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:33:43 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1315228918.26251.78.camel@vkoul-udesk3>
References: <1314688104.23734.1.camel@phoenix> <1315228918.26251.78.camel@vkoul-udesk3>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 5 Sep 2011 21:32:24 +0800
Message-ID: <CAF+7xWn+W=T0A02p2t-kCtYX0o5xL3pU+Q2AUOunZmYvGkhaWg@mail.gmail.com>
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of linux/module.h
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/5 Vinod Koul <vinod.koul@linux.intel.com>:
> On Tue, 2011-08-30 at 15:08 +0800, Axel Lin wrote:
>> Add missing include of linux/module.h to fix build error.
> I don't see this build error in my tree (based on rc4), In which config
> is this seen?
The patch is against linux-next tree.
I got the build error by "make imx_v4_v5_defconfig" on linux-next tree
( next-20110831 )

Regards,
Axel

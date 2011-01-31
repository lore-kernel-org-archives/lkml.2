Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1AaMWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:22:46 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50750 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab1AaMWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:22:45 -0500
Message-ID: <4D46A94C.7000700@ru.mvista.com>
Date: Mon, 31 Jan 2011 15:21:32 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-arm-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: dmaengine: i.MX dma fixes
References: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
In-Reply-To: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 31-01-2011 15:00, Sascha Hauer wrote:

> The following contains fixes for the i.MX dma driver.

> Sascha

> The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

>    Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

> are available in the git repository at:
>    git://git.pengutronix.de/git/imx/linux-2.6 dmaengine-imxdma

> Sascha Hauer (4):
>        dmaengine i.MX dma: set maximum segment size for our device
>        dmaengine i.MX dma: check sg entries for valid addresses and lengths
>        dmaengine i.MX DMA: do not initialize chan_id field
>        dmaengine i.MX dma: initialize dma capabilities outside channel loop

>   drivers/dma/imx-dma.c |   26 ++++++++++++++++++++++----
>   1 files changed, 22 insertions(+), 4 deletions(-)

    Actually, would have made sense to combine the analogous changes to SDMA 
and DMA drivers into the single patch...

WBR, Sergei

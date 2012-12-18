Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2LRQte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:49:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44264 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab2LRQtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:49:31 -0500
Message-ID: <50D09E97.5090805@wwwdotorg.org>
Date: Tue, 18 Dec 2012 09:49:27 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, wmb@firmworks.com
Subject: Re: [PATCH V2] serial: tegra: add serial driver
References: <1355813993-24867-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1355813993-24867-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 11:59 PM, Laxman Dewangan wrote:
> Nvidia's Tegra has multiple uart controller which supports:

A few nits:

That should be NVIDIA.

>  .../devicetree/bindings/serial/serial-tegra.txt    |   24 +

I strongly object to this name; I believe nvidia,tegra20-hsuart.txt is
correct.

> +NVIDIA Tegra20/Tegra30 high speed (dma based) UART controller driver.

DMA, UART (below), ... should be all capitals.

The binding looks reasonable to me. The few parts of the code I looked
at look OK.

> diff --git a/include/linux/platform_data/serial-tegra.h b/include/linux/platform_data/serial-tegra.h
> +#endif /* _SERIAL_TEGRA_H_ */
> +

There's a blank line at the end of the file.

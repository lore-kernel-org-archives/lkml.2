Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3AHWXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:23:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41549 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab3AHWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:23:50 -0500
Message-ID: <50EC9C72.7040002@wwwdotorg.org>
Date: Tue, 08 Jan 2013 15:23:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: alan@linux.intel.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-tegra@vger.kernel.org, wmb@firmworks.com
Subject: Re: [PATCH V4 RESEND] serial: tegra: add serial driver
References: <1357642664-10816-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1357642664-10816-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 03:57 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra has multiple UART controller which supports:
> - APB DMA based controller fifo read/write.
> - End Of Data interrupt in incoming data to know whether end
>   of frame achieve or not.
> - HW controlled RTS and CTS flow control to reduce SW overhead.
> 
> Add serial driver to use all above feature.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Alan Cox <alan@linux.intel.com>

The DT binding part of this patch,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2IJSVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:21:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49673 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab2IJSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:21:13 -0400
Message-ID: <504E2F95.6040808@wwwdotorg.org>
Date: Mon, 10 Sep 2012 12:21:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Vinod Koul <vinod.koul@intel.com>,
        djbw@fb.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] dma: tegra: make tegra_dma.chip_data a pointer to
 const data
References: <20120829084911.GE28643@pengutronix.de> <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1346230295-15898-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2012 02:51 AM, Uwe Kleine-König wrote:
> From: Laxman Dewangan <ldewangan@nvidia.com>
> 
> This prepares *of_device_id.data becoming const. Without this change
> the following warning would occur:
> 
> 	drivers/dma/tegra20-apb-dma.c: In function 'tegra_dma_probe':
> 	drivers/dma/tegra20-apb-dma.c:1210:9: warning: assignment discards 'const' qualifier from pointer target type [enabled by default]
> 
> [ukl: split Laxman's patch to prevent warnings in the middle of the
> series. Original patch was sent with msgid
> 1346217447-19730-1-git-send-email-ldewangan@nvidia.com]
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> Acked-by: Vinod Koul <vinod.koul@linux.intel.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Uwe,

I don't see these patches in linux-next, so compilation is still broken.
Can you please apply them? Thanks.

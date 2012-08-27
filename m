Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab2H0EZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 00:25:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55029 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2H0EZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 00:25:29 -0400
Message-ID: <503AF6B6.1010808@nvidia.com>
Date: Sun, 26 Aug 2012 21:25:26 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7Zu?= =?UTF-8?B?aWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: vinod.koul@intel.com, djbw@fb.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] dma: tegra: add const to of_device_id.data's structure
References: <1345976063-24437-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345976063-24437-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2012 03:14 AM, Laxman Dewangan wrote:
> The membe "data" of structure of_device_id is changed to const
> pointer. Hence initializing this with const type data.
> This will fix the compilation warning like
> drivers/dma/tegra20-apb-dma.c:1217:9: warning: assignment discards 'const' qualifier from
> pointer target type [enabled by default]
> 
> This warning came after the change
> ---------
> commit 98d7bbb9929bcc14e11ac8a55245a4f2dc174e17
> Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>     of: add const to struct *of_device_id.data
> ---------

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I wonder if this should go through Uwe's branch that made similar
changes for all other drivers though? Uwe now CC'd.


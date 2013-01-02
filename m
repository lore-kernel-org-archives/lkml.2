Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3ABTme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:42:34 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3ABTmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:42:31 -0500
Message-ID: <50E48DA4.2090601@wwwdotorg.org>
Date: Wed, 02 Jan 2013 12:42:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: config: Add TPS6586X RTC config
References: <1356209585-6506-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1356209585-6506-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 01:53 PM, Laxman Dewangan wrote:
> enable CONFIG_RTC_DRV_TPS6586X to have RTC driver support for
> ventana, harmony etc.

Applied (squashed into) Tegra's for-3.9/defconfig branch.


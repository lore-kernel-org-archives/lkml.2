Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2GBQBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:01:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59340 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2GBQBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:01:11 -0400
Message-ID: <4FF1C5C4.90706@wwwdotorg.org>
Date: Mon, 02 Jul 2012 10:01:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: vinod.koul@intel.com, dan.j.williams@intel.com, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: tegra: rename driver and compatible to match
 with dts
References: <1341217328-6676-1-git-send-email-ldewangan@nvidia.com> <1341217328-6676-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1341217328-6676-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 02:22 AM, Laxman Dewangan wrote:
> Rename the compatible name and driver name to match with
> tegra dts file and as per clock driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

The separate config options for the old and new DMA drivers should
prevent them conflicting with each-other, even though they both support
the same compatible values and driver name. Hence, this patch should be
fine.

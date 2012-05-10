Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762Ab2EJS7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:59:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37502 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2EJS7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:59:17 -0400
Message-ID: <4FAC1000.9070605@wwwdotorg.org>
Date: Thu, 10 May 2012 12:59:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, linux@arm.linux.org.uk,
        lrg@ti.com, broonie@opensource.wolfsonmicro.com, swarren@nvidia.com,
        olof@lixom.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/4] regulator: tps62360: support dts and enable for tegra-cardhu
References: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336643276-16796-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2012 03:47 AM, Laxman Dewangan wrote:
> Add support for dt on regulator device tps62360. Also  enable this regulator for Nvidia's
> Tegra platform - cardhu.
> This series:
> - Make the regulator_init_data as pointer type from platform data.
> - enable config variable in tegra defconfig
> - add entry for tps62360 in dts file of tegra-cardhu.

The series looks fine to me. I assume patches 1 & 2 will go through the
regulator tree and I'll take patches 3 & 4 through the Tegra tree.

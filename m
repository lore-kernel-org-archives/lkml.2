Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165Ab2JaIq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:46:58 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5207 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935082Ab2JaIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:46:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Oct 2012 01:46:39 -0700
Message-ID: <5090E50C.2090405@nvidia.com>
Date: Wed, 31 Oct 2012 14:15:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3] spi: tegra: add spi driver for SLINK controller
References: <1351580645-17260-1-git-send-email-ldewangan@nvidia.com> <20121030183854.GY4511@opensource.wolfsonmicro.com>
In-Reply-To: <20121030183854.GY4511@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 12:08 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Oct 30, 2012 at 12:34:05PM +0530, Laxman Dewangan wrote:
>> Tegra20/Tegra30 supports the spi interface through its SLINK
>> controller. Add spi driver for SLINK controller.
> Applied, thanks.
Thank you Mark and Stephen for quick review and merge.

Thanks,
Laxman

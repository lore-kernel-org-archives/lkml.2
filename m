Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab2GKKHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:07:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9068 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757061Ab2GKKHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:07:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Jul 2012 03:07:11 -0700
Message-ID: <4FFD4ECA.8090304@nvidia.com>
Date: Wed, 11 Jul 2012 15:30:42 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH RESEND] spi: tegra: use dmaengine based dma driver
References: <1341927517-4584-1-git-send-email-ldewangan@nvidia.com> <20120711095504.GD3938@opensource.wolfsonmicro.com>
In-Reply-To: <20120711095504.GD3938@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012 03:25 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Tue, Jul 10, 2012 at 07:08:37PM +0530, Laxman Dewangan wrote:
>> The new driver is selected if legacy driver is not
>> selected and new DMA driver is enabled through config
>> file.
> Is this any different to the version of the patch that I already
> applied?
I believe you have applied for the ASoC one. This is for spi one.
BTW, are you taking the same in regulator subsystem or created new for 
spi? I can verify from there.


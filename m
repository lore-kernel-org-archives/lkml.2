Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab2INP5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 11:57:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58517 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab2INP5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 11:57:39 -0400
Message-ID: <505353EF.7040904@wwwdotorg.org>
Date: Fri, 14 Sep 2012 09:57:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, grant.likely@secretlab.ca, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, vinod.koul@linux.intel.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 5/5] ASoC: tegra: remove support of legacy DMA driver
 based access
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com> <1345126397-28864-6-git-send-email-ldewangan@nvidia.com> <504936D3.8030203@wwwdotorg.org>
In-Reply-To: <504936D3.8030203@wwwdotorg.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 05:50 PM, Stephen Warren wrote:
> On 08/16/2012 08:13 AM, Laxman Dewangan wrote:
>> Remove the support code which uses the legacy APB DMA driver
>> for accessing the I2S FIFO.
>> The driver will use the dmaengine based APB DMA driver for
>> accessing reqding/writing to I2S FIFO.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> 
> Mark, Liam,
> 
> I'd like to take this patch through the Tegra tree, since it relies on
> the previous Tegra patches to convert to dmaengine. Could I please get
> an ack if that's OK? Thanks.

I'm still looking for an ack.


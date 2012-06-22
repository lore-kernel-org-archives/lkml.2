Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761293Ab2FVF4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:56:40 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6501 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2FVF4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:56:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 21 Jun 2012 22:56:33 -0700
Message-ID: <4FE408E9.6050909@nvidia.com>
Date: Fri, 22 Jun 2012 11:25:53 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Convert to regulator_list_voltage_table
References: <1340275546.2922.1.camel@phoenix> <1340275680.2922.3.camel@phoenix>
In-Reply-To: <1340275680.2922.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012 04:18 PM, Axel Lin wrote:
> Convert tps65910_ops and tps65910_ops_vdd3 to regulator_list_voltage_table.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
I am fine with this change.


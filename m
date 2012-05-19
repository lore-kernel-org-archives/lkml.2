Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab2ESPJO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 11:09:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17588 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab2ESPJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 11:09:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 19 May 2012 08:09:11 -0700
Message-ID: <4FB7B667.9010606@nvidia.com>
Date: Sat, 19 May 2012 20:34:07 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: DT support for input-supply of regulator.
References: <4FB67D9C.2040909@nvidia.com> <20120519104436.GR4039@opensource.wolfsonmicro.com>
In-Reply-To: <20120519104436.GR4039@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 May 2012 04:14 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Fri, May 18, 2012 at 10:19:32PM +0530, Laxman Dewangan wrote:
>
>> But when it looks for the device node containing this regulator, it
>> starts searching of the props from the dev_node of parent device
>> i.e. pmu: tps65910@d2 and in search, it does not found the
>> vin-supply property. It got property for compatible reg, gpio_cell,
>> gpio-controller and then no more property.
>> Is there any issue in laying down the regulator structure?
> I'm sorry but I'm having a really hard time parsing what you're saying
> above.  It sounds like there's some sort of device tree specific bug
> that needs fixing.
>

I found small issue in core regulator and the tps65910 regulator driver 
where it was not passing correct regulator node. After fixing this, it 
worked fine.
I already sent the patches for review.

Thanks,
Laxman



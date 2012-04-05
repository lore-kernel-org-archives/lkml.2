Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab2DEHLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 03:11:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7872 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2DEHL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 03:11:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Apr 2012 00:11:24 -0700
Message-ID: <4F7D4358.50000@nvidia.com>
Date: Thu, 5 Apr 2012 12:31:44 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 2/2] regulator: Convert rc5t583 to set_voltage
References: <1333605888.18055.1.camel@phoenix> <1333606056.18055.3.camel@phoenix>
In-Reply-To: <1333606056.18055.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2012 11:37 AM, Axel Lin wrote:
> Not every regulator driver should implement set_voltage_sel callback.
> See commit e8eef82
> "regulator: Provide a selector based set_voltage_sel() operation".
>
> For rc5t583, the regulator voltage can be mapped onto selector values with a
> simple calculation, thus implement set_voltage is better than set_voltage_sel.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---


I wanted to provide the settling delay whenever voltage output get 
change as per datasheet. In place of having this delay in the driver, I 
wanted to use implementation of core and for this I need to implement 
set_voltage_sel() not set_voltage().


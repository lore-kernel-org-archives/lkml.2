Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2EGMpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:45:21 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1880 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab2EGMpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:45:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 07 May 2012 05:45:18 -0700
Message-ID: <4FA7C31C.7000309@nvidia.com>
Date: Mon, 7 May 2012 18:12:04 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 4/4] regulator: tps62360: Provide settling time for
 voltage change
References: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com> <1336376139-1048-5-git-send-email-ldewangan@nvidia.com> <20120507112321.GI4415@opensource.wolfsonmicro.com>
In-Reply-To: <20120507112321.GI4415@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012 04:53 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, May 07, 2012 at 01:05:39PM +0530, Laxman Dewangan wrote:
>> Settling time is require when there is voltage output change.
>> Implement set_voltage_time_sel() callback which returns delay time
>> for voltage change to settle down to new value.
> This is fine but depends on your previous stylistic change so won't
> apply.  In general you should always try to order things so that there
> are fewer dependencies at the start of the series - there's no actual
> dependency between this and the stylistic changes you've made.
>
Thanks for quick review.

Yaah, I should put the stylistic change at end..
I will send next patch for enabling cache and settling time.
Will keep discussion on stylistic changes and so will remove that from 
this series.

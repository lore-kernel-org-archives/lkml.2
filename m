Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2JHG2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:28:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15924 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2JHG2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:28:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 07 Oct 2012 23:26:28 -0700
Message-ID: <50726ABC.4030502@nvidia.com>
Date: Mon, 8 Oct 2012 11:25:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] mfd: tps65090: move register access APIs to header
References: <1349623340-21807-1-git-send-email-ldewangan@nvidia.com> <1349623340-21807-5-git-send-email-ldewangan@nvidia.com> <D958900912E20642BCBC71664EFECE3E6DDF8AF387@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDF8AF387@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 October 2012 11:07 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Laxman Dewangan
>> Sent: Sunday, October 07, 2012 8:52 PM
>> To: sameo@linux.intel.com
>> Cc: linux-kernel@vger.kernel.org; Venu Byravarasu; Laxman Dewangan
>> Subject: [PATCH 4/5] mfd: tps65090: move register access APIs to header
>>
>> Since tps65090 register is accessed via regmap, moving
>> the register access APIs to header and making it as inline.
> Why should we move function implementation to header file?
> Also by making inline, doesn't the output binary size increase?

These function does not do much but just indirect the regmap calls so 
not seeing much size increase but better execution.
Also it will remove the complexity and code sizes from mfd drivers. The 
sub driver can use direct regmap calls if they want.



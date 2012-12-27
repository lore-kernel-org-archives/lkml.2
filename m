Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab2L0O7Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:59:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9664 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2L0O7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:59:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 27 Dec 2012 06:57:06 -0800
Message-ID: <50DC6242.1000404@nvidia.com>
Date: Thu, 27 Dec 2012 20:29:14 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS6586x
References: <1356102748-722-1-git-send-email-ldewangan@nvidia.com> <7345841.MepJzddHFh@ax5200p>
In-Reply-To: <7345841.MepJzddHFh@ax5200p>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 December 2012 08:26 PM, Marc Dietrich wrote:
> Hi Laxman,
>
> On Friday 21 December 2012 20:42:28 you wrote:
>
>> +
>> +	/* Set epoch start as 00:00:00:01:01:2000 */
>> +	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
> any reason why you hard coded it to 2000? All boards I know use 2009, so with
> this patch, everyone needs to set his clock again.
>

No specific reason. If 2009 should be default then I can push patch to 
set it as 2009.



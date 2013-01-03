Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3ACGRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:17:05 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11288 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3ACGRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:17:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Jan 2013 22:12:56 -0800
Message-ID: <50E5224D.7010404@nvidia.com>
Date: Thu, 3 Jan 2013 11:46:45 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Marc Dietrich <marvin24@gmx.de>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2] rtc: add RTC driver for TPS6586x
References: <1356102748-722-1-git-send-email-ldewangan@nvidia.com> <7345841.MepJzddHFh@ax5200p>	<50DC6242.1000404@nvidia.com> <20130102155057.9fb6ede2.akpm@linux-foundation.org>
In-Reply-To: <20130102155057.9fb6ede2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2013 05:20 AM, Andrew Morton wrote:
> On Thu, 27 Dec 2012 20:29:14 +0530
> Laxman Dewangan <ldewangan@nvidia.com> wrote:
>
>> On Thursday 27 December 2012 08:26 PM, Marc Dietrich wrote:
>>> Hi Laxman,
>>>
>>> On Friday 21 December 2012 20:42:28 you wrote:
>>>
>>>> +
>>>> +	/* Set epoch start as 00:00:00:01:01:2000 */
>>>> +	rtc->epoch_start = mktime(2000, 1, 1, 0, 0, 0);
>>> any reason why you hard coded it to 2000? All boards I know use 2009, so with
>>> this patch, everyone needs to set his clock again.
>>>
>> No specific reason. If 2009 should be default then I can push patch to
>> set it as 2009.
> I'd like to get this into Linus soon so let's get it finished.  I
> assume it's merely this?

Yes, the following change is only require. I was waiting for driver to 
be avilable on linux-next before sending patch to avoid any conflict.
Thanks a lot for taking care.


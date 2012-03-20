Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab2CTKtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:49:52 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:57043
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759568Ab2CTKtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:49:32 -0400
Message-ID: <4F6860AF.5060404@compulab.co.il>
Date: Tue, 20 Mar 2012 12:49:19 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20120201 Thunderbird/9.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
References: <1331882917-27960-1-git-send-email-vbyravarasu@nvidia.com> <20120316200154.GU20524@sortiz-mobl> <D958900912E20642BCBC71664EFECE3E6DD3127A5D@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD3127A5D@BGMAIL02.nvidia.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/12 10:43, Venu Byravarasu wrote:
> Thanks Mark and Samuel.
> 
>> -----Original Message-----
>> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
>> Sent: Saturday, March 17, 2012 1:32 AM
>> To: Venu Byravarasu
>> Cc: linux-kernel@vger.kernel.org; jedu@slimlogic.co.uk; lrg@slimlogic.co.uk;
>> broonie@opensource.wolfsonmicro.com; gg@slimlogic.co.uk
>> Subject: Re: [PATCH] mfd: Fix compilation error in TPS65910.h
>>
>> Hi Venu,
>>
>> On Fri, Mar 16, 2012 at 12:58:37PM +0530, Venu Byravarasu wrote:
>>> From: Venu Byravarasu <vbyravarasu@nvidia.com>
>>>
>>> Fix compilation error due to including TPS65910.h
>> Probably too late for 3.3, but I applied this patch anyway.

Venu,
Should this go also to stable?

If it should then, Samuel, can you please add Cc: stable@vger.kernel.org?


-- 
Regards,
Igor.

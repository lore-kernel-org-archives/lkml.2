Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2K0SWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:22:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15341 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2K0SWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:22:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6909"; a="10094571"
Message-ID: <50B504EE.3020704@codeaurora.org>
Date: Tue, 27 Nov 2012 10:22:38 -0800
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Cesar Eduardo Barros <cesarb@cesarb.net>, linux-kernel@vger.kernel.org,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 01/24] MAINTAINERS: remove drivers/platform/msm/
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net> <1353716808-16375-2-git-send-email-cesarb@cesarb.net> <20121126191022.GD12719@codeaurora.org>
In-Reply-To: <20121126191022.GD12719@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 11:10 AM, David Brown wrote:
> On Fri, Nov 23, 2012 at 10:26:25PM -0200, Cesar Eduardo Barros wrote:
>> Added by commit 8a5700c (add drivers/platform/msm to MSM subsystem) in
>> 2011, but I could not find any trace of that directory being ever added
>> to the repository.
>>
>> Cc: Kenneth Heitke <kheitke@codeaurora.org>
>> Cc: David Brown <davidb@codeaurora.org>
>> Cc: Daniel Walker <dwalker@fifo99.com>
>> Cc: Bryan Huntsman <bryanh@codeaurora.org>
>> Cc: linux-arm-msm@vger.kernel.org
>> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
>> ---
>>  MAINTAINERS | 1 -
> 
> The directory was proposed at one point as a location for platform
> data.  The ARM community has since come up with different ways of
> doing this.  So, it's fine to remove this.
> 
> Acked-by: David Brown <davidb@codeaurora.org>
> 

FWIW, Acked-by: Bryan Huntsman <bryanh@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

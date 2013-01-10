Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab3AJGbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 01:31:46 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19220 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3AJGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 01:31:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 09 Jan 2013 22:31:40 -0800
Message-ID: <50EE603B.7080702@nvidia.com>
Date: Thu, 10 Jan 2013 12:01:23 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V4 0/4] input: keyboard: tegra: cleanups and DT supports
References: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com> <50EAFD36.9070909@wwwdotorg.org>
In-Reply-To: <50EAFD36.9070909@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Monday 07 January 2013 10:22 PM, Stephen Warren wrote:
> On 01/06/2013 04:14 AM, Laxman Dewangan wrote:
>> This patch series:
>>   - fix build warning,
>>   - use devm_* for allocation,
>>   - make column/rows configuration through DT and
>>   - remove the rarely used  key mapping table.
> The series,
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
>

If you are fine with this series then can it be apply please? I can 
handle if there is any comment on this series to close this.

Thanks,
Laxman


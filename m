Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2DSJOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:14:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34040 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab2DSJOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:14:41 -0400
Message-ID: <4F8FD773.5030500@linaro.org>
Date: Thu, 19 Apr 2012 11:14:27 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Rob Lee <rob.lee@linaro.org>,
        Ricardo Salveti <ricardo.salveti@linaro.org>
Subject: Re: [RFC PATCH] cpuidle: allow per cpu latencies
References: <1333619620-21201-1-git-send-email-pdeschrijver@nvidia.com> <4F7DA009.4010802@linux.intel.com> <CAMQu2gzwe0F3qcaTqASEPUASdG1SjpUxrBrSp-RrYLgy3W24OQ@mail.gmail.com> <4F7F0D52.8080305@linaro.org> <20120410102857.GA22721@tbergstrom-lnx.Nvidia.com> <20120416153456.GB514@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20120416153456.GB514@tbergstrom-lnx.Nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2012 05:34 PM, Peter De Schrijver wrote:
>>
>> Maybe we also want to make the 'disabled' flag per CPU then or provide some
>> other way the number of C states can be different per CPU?
>
> What do you think about this? Do we also want to make the disabled flag per
> CPU? Or how should we deal with a different number of C states per CPU?

Hi Peter,

yes, that could makes sense. But in most of the architecture, this is 
not needed, so duplicating the state's array and latencies is unneeded 
memory consumption.

Maybe we can look for a COW approach, similar to what is done for the 
nsproxy structure, no ?



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


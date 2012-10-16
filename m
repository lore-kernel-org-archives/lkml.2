Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2JPKlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:41:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33996 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab2JPKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:41:35 -0400
Message-ID: <507D39E5.5010301@gmail.com>
Date: Tue, 16 Oct 2012 18:41:41 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ni zhan Chen <nizhan.chen@gmail.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        mhocko@suse.cz, linux-kernel@vger.kernel.org,
        Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com> <507D34E3.3040705@gmail.com>
In-Reply-To: <507D34E3.3040705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 06:20 PM, Ni zhan Chen wrote:
> On 10/16/2012 06:12 PM, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Sysctl oom_kill_allocating_task enables or disables killing the 
>> OOM-triggering
>> task in out-of-memory situations, but it only works on overall 
>> system-wide oom.
>> But it's also a useful indication in memcg so we take it into 
>> consideration
>> while oom happening in memcg. Other sysctl such as panic_on_oom has 
>> already
>> been memcg-ware.
>
> Is it the resend one or new version, could you add changelog if it is 
> the last case?

Sorry, forget to mention that this patch is an updated one rebased on 
mhocko mm tree, since-3.6 branch.
The first one is on old kernel, please ignore it. :-)


Thanks,
Sha


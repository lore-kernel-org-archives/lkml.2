Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264Ab2GDLVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:21:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33284 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2GDLU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:20:58 -0400
Message-ID: <4FF42711.50303@gmail.com>
Date: Wed, 04 Jul 2012 19:20:49 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 7/7] memcg: print more detailed info while memcg oom happening
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881609-5935-1-git-send-email-handai.szj@taobao.com> <4FF3FED6.9010700@jp.fujitsu.com>
In-Reply-To: <4FF3FED6.9010700@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 04:29 PM, Kamezawa Hiroyuki wrote:
> (2012/06/28 20:06), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> While memcg oom happening, the dump info is limited, so add this
>> to provide memcg page stat.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> Could you split this into a different series ?
> seems good to me in general but...one concern is hierarchy handling.
>
> IIUC, the passed 'memcg' is the root of hierarchy which gets OOM.
> So, the LRU info, which is local to the root memcg, may not contain any good
> information. I think you should visit all memcg under the tree.
>
Yes, you're right!
I did not handle hierarchy here, and just now I make a test case to
prove this.
I'll split it to another series later.

Thanks for reviewing!


Thanks,
Sha

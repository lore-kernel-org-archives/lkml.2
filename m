Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab2GDIYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:24:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56915 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853Ab2GDIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:24:41 -0400
Message-ID: <4FF3FDC3.9070108@gmail.com>
Date: Wed, 04 Jul 2012 16:24:35 +0800
From: Sha Zhengju <handai.szj@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com,
        yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz,
        linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881525-5835-1-git-send-email-handai.szj@taobao.com> <4FF291BE.7030509@jp.fujitsu.com>
In-Reply-To: <4FF291BE.7030509@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 02:31 PM, Kamezawa Hiroyuki wrote:
> (2012/06/28 20:05), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
>> rule still is:
>> 	mem_cgroup_begin_update_page_stat()
>> 	modify page WRITEBACK stat
>> 	mem_cgroup_update_page_stat()
>> 	mem_cgroup_end_update_page_stat()
>>
>> There're two writeback interface to modify: test_clear/set_page_writeback.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> Seems good to me. BTW, you named macros as MEM_CGROUP_STAT_FILE_XXX
> but I wonder these counters will be used for accounting swap-out's dirty pages..
>
> STAT_DIRTY, STAT_WRITEBACK ? do you have better name ?

Okay, STAT_DIRTY/WRITEBACK seem good, I'll change them in next version.


Thanks,
Sha

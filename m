Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab1HKIV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:21:28 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:53427 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1HKIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:21:25 -0400
Message-ID: <4E4390FC.7090103@linux.vnet.ibm.com>
Date: Thu, 11 Aug 2011 13:51:16 +0530
From: Raghavendra K T <raghukt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Arend van Spriel <arend@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2][cleanup] memcg: renaming of mem variable to memcg
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com> <20110810172942.23280.99644.sendpatchset@oc5400248562.ibm.com> <20110811080500.GC8023@tiehlicka.suse.cz>
In-Reply-To: <20110811080500.GC8023@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 01:35 PM, Michal Hocko wrote:
> On Wed 10-08-11 22:59:42, Raghavendra K T wrote:
>>   The memcg code sometimes uses "struct mem_cgroup *mem" and sometimes uses
>>   "struct mem_cgroup *memcg". This patch renames all mem variables to memcg in header file.
>
> Any reason (other than that this is a different file) to have this as a
> separate patch?
>
Yes you are right, There is no much significant reason. since source 
file patch was so huge and viable for conflicts, thought it would apply 
clean easily.
>>
>> From: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> Signed-off-by: Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>
>> ---
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 5633f51..fb1ed1c 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -88,8 +88,8 @@ extern void mem_cgroup_uncharge_end(void);
>>   extern void mem_cgroup_uncharge_page(struct page *page);
>>   extern void mem_cgroup_uncharge_cache_page(struct page *page);
(snip)
>>   }
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
>> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>
>


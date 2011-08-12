Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab1HLG71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 02:59:27 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:46183 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1HLG70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 02:59:26 -0400
Message-ID: <4E44CF3B.5050500@linux.vnet.ibm.com>
Date: Fri, 12 Aug 2011 12:29:07 +0530
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
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2][cleanup] memcg: renaming of mem variable to memcg
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com> <20110810172929.23280.76419.sendpatchset@oc5400248562.ibm.com> <20110811080447.GB8023@tiehlicka.suse.cz> <4E439962.4040105@linux.vnet.ibm.com> <20110811090318.GE8023@tiehlicka.suse.cz>
In-Reply-To: <20110811090318.GE8023@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 02:33 PM, Michal Hocko wrote:
> On Thu 11-08-11 14:27:06, Raghavendra K T wrote:
>> On 08/11/2011 01:34 PM, Michal Hocko wrote:
>>> On Wed 10-08-11 22:59:29, Raghavendra K T wrote:
>>> [...]
>>>> This patch renames all mem variables to memcg in source file.
>>>
>>> __mem_cgroup_try_charge for example uses local mem which cannot be
>>> renamed because it already has a memcg argument (mem_cgroup **) then we
>>> have mem_cgroup_try_charge_swapin and mem_cgroup_prepare_migration which
>>> use mem_cgroup **ptr (I guess we shouldn't have more of them).
>>> I think that __mem_cgroup_try_charge should use ptr pattern as well.
>>> Other than that I think the clean up is good.
>>>
>>> With __mem_cgroup_try_charge:
>>> Acked-by: Michal Hocko<mhocko@suse.cz>
>>>
>>> Thanks
>> Agreed, Let me know whether you prefer whole patch to be posted or
>> only the corresponding hunk.
>
> I would go with the full (single) patch. I would also recommend to add
> results of your tests into the changelog (which configurantion have been
> tested and how did you test binary compatibility).
>
> Thanks
Agreed. Thanks. To summarise, I have to get both the patches with 
__mem_cgroup_try_charge changes into a single file, along with 
configuration + binary compatible test in change log.
I 'll be sending v2 patch in next mail.
Regards

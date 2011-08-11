Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1HKIR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:17:59 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:51356 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab1HKIR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:17:56 -0400
Message-ID: <4E438FD3.7070000@linux.vnet.ibm.com>
Date: Thu, 11 Aug 2011 13:46:19 +0530
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
Subject: Re: [PATCH 0/2][cleanup] memcg: renaming of mem variable to memcg
References: <20110810172917.23280.9440.sendpatchset@oc5400248562.ibm.com> <20110811075337.GA8023@tiehlicka.suse.cz>
In-Reply-To: <20110811075337.GA8023@tiehlicka.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 01:23 PM, Michal Hocko wrote:
> On Wed 10-08-11 22:59:17, Raghavendra K T wrote:
>> Hi,
>>   This is the memcg cleanup patch for that was talked little ago to change the  "struct
>>   mem_cgroup *mem" variable to  "struct mem_cgroup *memcg".
>>
>>   The patch is though trivial, it is huge one.
>>   Testing : Compile tested with following configurations.
>>   1) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
>>   2) CONFIG_CGROUP_MEM_RES_CTLR=y  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
>>   3) CONFIG_CGROUP_MEM_RES_CTLR=n  CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n
>
> How exactly have you tested? Compiled and compared before/after binaries
> (it shouldn't change, right)?
Yes, But idea was to ensure that both #ifdef and #else part are hit 
during compilation, which could expose some corrections needed.
>
>>
>>   Also tested basic mounting with memcgroup.
>>   Raghu.
>
> Thanks


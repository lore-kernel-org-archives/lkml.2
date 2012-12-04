Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2LDKc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:32:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2443 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2LDKcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:32:18 -0500
X-IronPort-AV: E=Sophos;i="4.83,370,1352044800"; 
   d="scan'208";a="6330811"
Message-ID: <50BDD0F4.8040806@cn.fujitsu.com>
Date: Tue, 04 Dec 2012 18:31:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Jiang Liu <liuj97@gmail.com>, Len Brown <len.brown@intel.com>,
        benh@kernel.crashing.org, paulus@samba.org,
        Christoph Lameter <cl@linux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jianguo Wu <wujianguo@huawei.com>
Subject: Re: [Patch v4 03/12] memory-hotplug: remove redundant codes
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <1354010422-19648-4-git-send-email-wency@cn.fujitsu.com> <50BDC0DE.4010103@cn.fujitsu.com>
In-Reply-To: <50BDC0DE.4010103@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/04 18:31:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/04 18:31:38,
	Serialize complete at 2012/12/04 18:31:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 05:22 PM, Tang Chen wrote:
> On 11/27/2012 06:00 PM, Wen Congyang wrote:
>> offlining memory blocks and checking whether memory blocks are offlined
>> are very similar. This patch introduces a new function to remove
>> redundant codes.
>>
>> CC: David Rientjes<rientjes@google.com>
>> CC: Jiang Liu<liuj97@gmail.com>
>> CC: Len Brown<len.brown@intel.com>
>> CC: Christoph Lameter<cl@linux.com>
>> Cc: Minchan Kim<minchan.kim@gmail.com>
>> CC: Andrew Morton<akpm@linux-foundation.org>
>> CC: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> CC: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
>> Signed-off-by: Wen Congyang<wency@cn.fujitsu.com>
>
> Can we merge this patch with [PATCH 03/12] ?

Sorry, I think we can merge this patch into [PATCH 02/12].
Thanks. :)

>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
>

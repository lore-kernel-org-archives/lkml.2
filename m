Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2LDJsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:48:07 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44874 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2LDJsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:48:01 -0500
X-IronPort-AV: E=Sophos;i="4.83,370,1352044800"; 
   d="scan'208";a="6330127"
Message-ID: <50BDC694.1060509@cn.fujitsu.com>
Date: Tue, 04 Dec 2012 17:47:00 +0800
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
Subject: Re: [Patch v4 08/12] memory-hotplug: remove memmap of sparse-vmemmap
References: <1354010422-19648-1-git-send-email-wency@cn.fujitsu.com> <1354010422-19648-9-git-send-email-wency@cn.fujitsu.com>
In-Reply-To: <1354010422-19648-9-git-send-email-wency@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/04 17:47:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/04 17:47:22,
	Serialize complete at 2012/12/04 17:47:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 06:00 PM, Wen Congyang wrote:
>   static int __remove_section(struct zone *zone, struct mem_section *ms)
>   {
>   	unsigned long flags;
> @@ -330,9 +317,9 @@ static int __remove_section(struct zone *zone, struct mem_section *ms)
>   	pgdat_resize_lock(pgdat,&flags);
>   	sparse_remove_one_section(zone, ms);
>   	pgdat_resize_unlock(pgdat,&flags);
> -	return 0;
> +
> +	return ret;

I think we don't need to change this line. :)

Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>


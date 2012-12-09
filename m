Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030429Ab2LIILs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 03:11:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5768 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030308Ab2LIILr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 03:11:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,246,1355068800"; 
   d="scan'208";a="6359516"
Message-ID: <50C44786.30509@cn.fujitsu.com>
Date: Sun, 09 Dec 2012 16:10:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@huawei.com>
CC: Jiang Liu <liuj97@gmail.com>, hpa@zytor.com, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, linfeng@cn.fujitsu.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 4/5] page_alloc: Make movablecore_map has higher priority
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-5-git-send-email-tangchen@cn.fujitsu.com> <50BF6BA0.8060505@gmail.com> <50BFF443.3090504@cn.fujitsu.com> <50C00259.50901@huawei.com>
In-Reply-To: <50C00259.50901@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/09 16:10:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/09 16:10:57,
	Serialize complete at 2012/12/09 16:10:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu, Wu,

On 12/06/2012 10:26 AM, Jiang Liu wrote:
> On 2012-12-6 9:26, Tang Chen wrote:
>> On 12/05/2012 11:43 PM, Jiang Liu wrote:
>>> If we make "movablecore_map" take precedence over "movablecore/kernelcore",
>>> the logic could be simplified. I think it's not so attractive to support
>>> both "movablecore_map" and "movablecore/kernelcore" at the same time.

Thanks for the advice of removing movablecore/kernelcore. But since we
didn't plan to do this in the beginning, and movablecore/kernelcore are
more user friendly, I think for now, I'll handle DMA and low memory 
address problems as you mentioned, and just keep movablecore/kernelcore
in the next version. :)

And about the SRAT, I think it is necessary to many users. I think we
should provide both interfaces. I may give a try in the next version.

Thanks. :)


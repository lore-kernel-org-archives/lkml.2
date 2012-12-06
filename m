Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946424Ab2LFRmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:42:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946067Ab2LFRme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:42:34 -0500
Message-ID: <50C0D8B5.6000304@zytor.com>
Date: Thu, 06 Dec 2012 09:41:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, wujianguo@huawei.com, qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B4304F.4070302@cn.fujitsu.com> <50B45021.2000009@zytor.com> <50C0D5C6.1050305@gmail.com>
In-Reply-To: <50C0D5C6.1050305@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 09:28 AM, Jiang Liu wrote:
> Hi hpa and Tang,
> 	How do you think about the attached patches, which reserves memory
> for hotplug from memblock/bootmem allocator at early booting stages?

I don't see any attached patches?

	-hpa


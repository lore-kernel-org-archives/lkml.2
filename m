Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab2K0JlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:41:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:45428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758342Ab2K0JlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:41:17 -0500
X-IronPort-AV: E=Sophos;i="4.83,327,1352044800"; 
   d="scan'208";a="6284595"
Message-ID: <50B48C3B.8080408@cn.fujitsu.com>
Date: Tue, 27 Nov 2012 17:47:39 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Bob Liu <lliubbo@gmail.com>,
        akpm@linux-foundation.org, rob@landley.net,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 0/5] Add movablecore_map boot option
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <CAA_GA1d7CxHvmZELvD_DO6u5tu1WBqfmLiuEzeFo=xMzuW50Tg@mail.gmail.com> <50B479FA.6010307@cn.fujitsu.com> <50B47EB7.20000@zytor.com>
In-Reply-To: <50B47EB7.20000@zytor.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:40:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/27 17:40:50,
	Serialize complete at 2012/11/27 17:40:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 11/27/2012 04:49 PM, H. Peter Anvin Wrote:
> On 11/27/2012 12:29 AM, Tang Chen wrote:
>> Another approach is like the following:
>> movable_node = 1,3-5,8
>> This could set all the memory on the nodes to be movable. And the rest
>> of memory works as usual. But movablecore_map is more flexible.
> 
> ... but *much* harder for users, so movable_node is better in most cases.

But numa is initialized very later, and we need the information in SRAT...

Thanks
Wen Congyang

> 
> 	-hpa
> 
> 


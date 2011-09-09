Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab1IIMCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:02:18 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37993 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933764Ab1IIMCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:02:17 -0400
Message-ID: <4E6A001C.2040600@parallels.com>
Date: Fri, 9 Sep 2011 09:01:32 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.osdl.org>, <netdev@vger.kernel.org>,
        <xemul@parallels.com>, "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v2 6/9] per-cgroup tcp buffers control
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-7-git-send-email-glommer@parallels.com> <20110909121206.e1d628d1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110909121206.e1d628d1.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2011 12:12 AM, KAMEZAWA Hiroyuki wrote:
> On Wed,  7 Sep 2011 01:23:16 -0300
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> With all the infrastructure in place, this patch implements
>> per-cgroup control for tcp memory pressure handling.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>
> Hmm, then, kmem_cgroup.c is just a caller of plugins implemented
> by other components ?

Kame,

Refer to my discussion with Greg. How would you feel about it being 
accounted to a single "kernel memory" limit in memcg?

Thanks!

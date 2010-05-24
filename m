Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0EXBOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:14:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56920 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0EXBOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:14:00 -0400
Message-ID: <4BF9D265.70008@cn.fujitsu.com>
Date: Mon, 24 May 2010 09:12:05 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] io-controller: Add new interfaces to trace	backlogged
 group status
References: <4BF64712.1070500@cn.fujitsu.com> <20100521131751.GA15302@redhat.com>
In-Reply-To: <20100521131751.GA15302@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, May 21, 2010 at 04:40:50PM +0800, Gui Jianfeng wrote:
>> Hi,
>>
>> This series implements three new interfaces to keep track of tranferred bytes,
>> elapsing time and io rate since group getting backlogged. If the group dequeues
>> from service tree, these three interfaces will reset and shows zero.
> 
> Hi Gui,
> 
> Can you give some details regarding how this functionality is useful? Why
> would somebody be interested in only in stats of till group was
> backlogged and not in total stats?
> 
> Groups can come and go so fast and these stats will reset so many times
> that I am not able to visualize how these stats will be useful.

Hi Vivek,

Currently, we assign weight to a group, but user still doesn't know how fast the
group runs. With io rate interface, users can check the rate of a group at any
moment, or to determine whether the weight assigned to a group is enough.
bytes and time interface is just for debug purpose.

Thanks,
Gui

> 
> Thanks
> Vivek
> 
>> Thanks
>> Gui
> 
> 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0DLGdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 02:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0DLGdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 02:33:32 -0400
Message-ID: <4BC2BE6A.4030500@redhat.com>
Date: Mon, 12 Apr 2010 14:32:10 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Changli Gao <xiaosuo@gmail.com>
CC: linux-kernel@vger.kernel.org, Octavian Purdila <opurdila@ixiacom.com>,
       ebiederm@xmission.com, Eric Dumazet <eric.dumazet@gmail.com>,
       netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch 2/3] sysctl: add proc_do_large_bitmap
References: <20100409101442.5051.99812.sendpatchset@localhost.localdomain> 	<20100409101503.5051.3805.sendpatchset@localhost.localdomain> <s2w412e6f7f1004090333g3b23eb94udb1e6cc3939a07e5@mail.gmail.com>
In-Reply-To: <s2w412e6f7f1004090333g3b23eb94udb1e6cc3939a07e5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> On Fri, Apr 9, 2010 at 6:11 PM, Amerigo Wang <amwang@redhat.com> wrote:
>> From: Octavian Purdila <opurdila@ixiacom.com>
>>
>> The new function can be used to read/write large bitmaps via /proc. A
>> comma separated range format is used for compact output and input
>> (e.g. 1,3-4,10-10).
>>
>> Writing into the file will first reset the bitmap then update it
>> based on the given input.
>>
> 
> We have bitmap_scnprintf() and bitmap_parse_user(), why invent a new suite?
> 
> 

Because they don't accept '-'.


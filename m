Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2DYOmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:42:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55898 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab2DYOmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:42:33 -0400
Message-ID: <4F980CF2.9020905@parallels.com>
Date: Wed, 25 Apr 2012 11:40:50 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] res_counter: Account max_usage when calling res_counter_charge_nofail()
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com> <1335309096-12886-3-git-send-email-fweisbec@gmail.com> <4F97456B.5090201@jp.fujitsu.com>
In-Reply-To: <4F97456B.5090201@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:29 PM, KAMEZAWA Hiroyuki wrote:
> (2012/04/25 8:11), Frederic Weisbecker wrote:
> 
>> Updating max_usage is something one would expect when we reach
>> a new maximum usage value even when we do this by forcing through
>> the limit with res_counter_charge_nofail().
>>
>> (Whether we want to account failcnt when we force through the limit
>> is another debate).
>>
>> Signed-off-by: Frederic Weisbecker<fweisbec@gmail.com>
>> Cc: Tejun Heo<tj@kernel.org>
>> Cc: Li Zefan<lizefan@huawei.com>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Glauber Costa<glommer@parallels.com>
>> Cc: Kirill A. Shutemov<kirill@shutemov.name>
> 
> 
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> 
Acked-by: Glauber Costa <glommer@parallels.com>

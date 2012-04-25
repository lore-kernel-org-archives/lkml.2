Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2DYOmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:42:16 -0400
Received: from mx2.parallels.com ([64.131.90.16]:55878 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab2DYOmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:42:15 -0400
Message-ID: <4F980CDF.7030004@parallels.com>
Date: Wed, 25 Apr 2012 11:40:31 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/2] res_counter: Merge res_counter_charge and res_counter_charge_nofail
References: <1335309096-12886-1-git-send-email-fweisbec@gmail.com> <1335309096-12886-2-git-send-email-fweisbec@gmail.com> <4F974545.1060107@jp.fujitsu.com>
In-Reply-To: <4F974545.1060107@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:28 PM, KAMEZAWA Hiroyuki wrote:
> (2012/04/25 8:11), Frederic Weisbecker wrote:
> 
>> These two functions do almost the same thing and duplicate some code.
>> Merge their implementation into a single common function.
>> res_counter_charge_locked() takes one more parameter but it doesn't seem
>> to be used outside res_counter.c yet anyway.
>>
>> There is no (intended) change in the behaviour.
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

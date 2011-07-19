Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1GSHGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 03:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1GSHGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 03:06:39 -0400
Message-ID: <4E252CA1.803@redhat.com>
Date: Tue, 19 Jul 2011 15:05:05 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <andi@firstfloor.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>	 <20110718135243.GA5349@suse.de>  <4E25221F.6060605@redhat.com> <1311058498.16961.15.camel@edumazet-laptop>
In-Reply-To: <1311058498.16961.15.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月19日 14:54, Eric Dumazet 写道:
> Le mardi 19 juillet 2011 à 14:20 +0800, Cong Wang a écrit :
>
>> Hmm, since we don't have to enable SYSFS for NUMA, how about
>> make a new Kconfig for drivers/base/node.c? I.e., CONFIG_NUMA_SYSFS,
>> like patch below.
>>
>
> I dont quite understand this patch, nor the idea behind it.
>
> You can have a NUMA kernel (for appropriate percpu locality or whatever
> kernel data), and yet user land processes unable to use numactl if SYSFS
> is not enabled. I dont see a problem.
>

Both Pekka and Mel pointed out that it makes sense to have NUMA kernel
without SYSFS, this means sysfs interface is not a must for NUMA kernel.
Thus, I think it makes sense to separate the numa sysfs code out.

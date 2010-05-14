Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818Ab0ENUnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:43:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:38898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab0ENUnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:43:23 -0400
Message-ID: <4BEDB5EA.5000305@suse.cz>
Date: Fri, 14 May 2010 22:43:22 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] kconfig: print symbol type in help text
References: <4BE3AB91.80606@cn.fujitsu.com> <4BECF467.1060600@cn.fujitsu.com>
In-Reply-To: <4BECF467.1060600@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.5.2010 08:57, Li Zefan wrote:
> Hi Michal, what do you think about those patches? Seems
> Randy has had no further comments on them.

Sorry, I've been quite busy this week due to a new arrival in our
family. The patches are ok, thank you for your work and Randy for his
review! I'll apply them.

Michal

> 
> Li Zefan wrote:
>> Randy suggested to print out the symbol type in gconfig.
>>
>> Note this change does more than Randy's suggestion, that it also
>> affects menuconfig and "make config".
>>
>>   │ Symbol: BLOCK [=y]
>>   │ Type  : boolean
>>   │ Prompt: Enable the block layer
>>   │   Defined at block/Kconfig:4
>>   │   Depends on: EMBEDDED [=n]
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

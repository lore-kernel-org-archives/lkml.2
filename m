Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1GAKKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:10:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1GAKKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:10:41 -0400
Message-ID: <4E0D9D16.7020508@redhat.com>
Date: Fri, 01 Jul 2011 18:10:30 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
References: <20110701151931.4c2d78b5.sfr@canb.auug.org.au>	<4E0D5BD4.6080403@redhat.com> <20110701170843.bd60e326.sfr@canb.auug.org.au>
In-Reply-To: <20110701170843.bd60e326.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年07月01日 15:08, Stephen Rothwell 写道:
> Hi,
>
> On Fri, 01 Jul 2011 13:32:04 +0800 Cong Wang<amwang@redhat.com>  wrote:
>>
>> 于 2011年07月01日 13:19, Stephen Rothwell 写道:
>>>
>>> After merging the akpm tree, today's linux-next build (powerpc
>>> ppc64_defconfig) failed like this:
>>>
>>> arch/powerpc/kernel/rtas.c: In function 'rtas_restart':
>>> arch/powerpc/kernel/rtas.c:655:24: error: 'SYS_RESTART' undeclared (first use in this function)
>>> arch/powerpc/kernel/rtas.c: In function 'rtas_power_off':
>>> arch/powerpc/kernel/rtas.c:664:24: error: 'SYS_POWER_OFF' undeclared (first use in this function)
>>> arch/powerpc/kernel/rtas.c: In function 'rtas_halt':
>>> arch/powerpc/kernel/rtas.c:674:24: error: 'SYS_HALT' undeclared (first use in this function)
>>>
>>> Caused by commit ac050ff2a176 ("It is not necessary to share the same
>>> notifier.h").
>>
>> I think the following patch will fix this.
>
> Please find all the other files that need that include as well (there is
> at least one more).
>

Ok, I will do a cross-compilation.

Thanks.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab2BCC21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 21:28:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53393 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2BCC20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 21:28:26 -0500
Message-ID: <4F2B45F6.7020704@zytor.com>
Date: Thu, 02 Feb 2012 18:27:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org> <20120202152632.c356719a.akpm@linux-foundation.org>
In-Reply-To: <20120202152632.c356719a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 03:26 PM, Andrew Morton wrote:
>>
>> --- linux-2.6.git.orig/kernel/Makefile
>> +++ linux-2.6.git/kernel/Makefile
>> @@ -25,6 +25,7 @@ endif
>>   obj-y += sched/
>>   obj-y += power/
>>
>> +obj-$(CONFIG_X86) += kcmp.o
>
> Can we turn this into obj-$(CONFIG_CHECKPOINT_RESTART) and add the
> cond_syscall to sys_ni.c?
>
> I keep saying this, because "hey, we can delete it all again" figures
> largely in my rationale for merging your code ;)
>

Ah, yes please.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab2AQSs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:48:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53735 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab2AQSs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:48:28 -0500
Message-ID: <4F15C249.3000602@zytor.com>
Date: Tue, 17 Jan 2012 10:47:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
References: <20120117142759.GE16213@moon> <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com> <20120117144452.GG16213@moon>
In-Reply-To: <20120117144452.GG16213@moon>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2012 06:44 AM, Cyrill Gorcunov wrote:
> On Tue, Jan 17, 2012 at 04:38:14PM +0200, Alexey Dobriyan wrote:
>> On 1/17/12, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> +#define KCMP_EQ		0
>>> +#define KCMP_LT		1
>>> +#define KCMP_GT		2
>>
>> LT and GT are meaningless.
>>
> 
> I found symbolic names better than open-coded values. But sure,
> if this is problem it could be dropped.
> 
> Or you mean that in general anything but 'equal' is useless?
> 

Why on Earth would user space need to know which order in memory certain
kernel objects are?

Keep in mind that this is *exactly* the kind of information which makes
rootkits easier.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


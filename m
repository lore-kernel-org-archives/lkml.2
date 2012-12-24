Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2LXXem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 18:34:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34701 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab2LXXek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 18:34:40 -0500
Message-ID: <50D8E671.3020502@zytor.com>
Date: Mon, 24 Dec 2012 15:34:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 24/27] x86: Add swiotlb force off support
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <1355814959-10573-25-git-send-email-yinghai@kernel.org> <20121222023741.GF3468@phenom.dumpdata.com> <87bodmhkns.fsf@xmission.com> <20121222031019.GA4120@phenom.dumpdata.com> <87pq22g488.fsf@xmission.com> <50D52841.9030301@zytor.com> <CAE9FiQWY+LTZkmWmDvoLmrayG+a0uScpR=YThr+hogOU7HbJ9w@mail.gmail.com>
In-Reply-To: <CAE9FiQWY+LTZkmWmDvoLmrayG+a0uScpR=YThr+hogOU7HbJ9w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 09:11 PM, Yinghai Lu wrote:
> On Fri, Dec 21, 2012 at 7:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 12/21/2012 07:23 PM, Eric W. Biederman wrote:
>>>
>>> In this case YH has been working on the case of loading a kernel
>>> completely above 4G, and apparently he has also been testing the case of
>>> running a kernel with no memory below 4G.
>>>
>>
>> It is worth noting that we cannot run with *no* memory below 4G -- it is
>> not possible to run SMP at least without some memory below the 1M mark.
> 
> yes need keep 8k or so for trampoline.
> 
> but kdump only use one CPU.
> 

... except we have an active request to change that, and the trampoline
is more like 20K depending on options.

	-hpa



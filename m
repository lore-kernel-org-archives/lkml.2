Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2I1JAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 05:00:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63027 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2I1JAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 05:00:21 -0400
Message-ID: <50656733.3040609@gmail.com>
Date: Fri, 28 Sep 2012 11:00:35 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: suresh.b.siddha@intel.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, dwmw2@infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org, linux-mm <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: mtd: kernel BUG at arch/x86/mm/pat.c:279!
References: <1340959739.2936.28.camel@lappy>  <CA+1xoqdgKV_sEWvUbuxagL9JEc39ZFa6X9-acP7j-M7wvW6qbQ@mail.gmail.com>  <CA+55aFzJCLxVP+WYJM-gq=aXx5gmdgwC7=_Gr2Tooj8q+Dz4dw@mail.gmail.com>  <1347057778.26695.68.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFwW9Q+DM2gZy7r3JQJbrbMNR6sN+jewc2CY0i1wD_X=Tw@mail.gmail.com>  <1347062045.26695.82.camel@sbsiddha-desk.sc.intel.com>  <CA+55aFzeKcV5hROLJE31dNi3SEs+s6o0LL=96Kh8QGHPx=aZnA@mail.gmail.com> <1347202600.5876.7.camel@sbsiddha-ivb> <505068F4.4080309@gmail.com> <50506A6C.30109@gmail.com>
In-Reply-To: <50506A6C.30109@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:56 PM, Sasha Levin wrote:
> On 09/12/2012 12:50 PM, Sasha Levin wrote:
>> On 09/09/2012 04:56 PM, Suresh Siddha wrote:
>>> On Sat, 2012-09-08 at 12:57 -0700, Linus Torvalds wrote:
>>>>> Whatever. Something like this (TOTALLY UNTESTED) attached patch should
>>>>> get the mtdchar overflows to go away, 
>>> It looks good to me. Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
>>>
>>> Sasha, can you please give this a try?
>>
>> Sorry for the delay. It looks good here.
>>
>>
>> Thanks,
>> Sasha
>>
> 
> Uh... sorry again, I obviously tested the second patch sent by Linus but
> mistakingly replied to the wrong mail in the thread.

Is anyone planning on picking up Linus' patch? This is still not in -next even.


Thanks,
Sasha


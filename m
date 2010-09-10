Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab0IJX1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:27:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41834 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0IJX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:27:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hOYpfSWPE9Abs+B7aA9PTaOvdqln421nbkfNEpZTgtYn1UCW6PE3MREkKvrcJ91URZ
         gIPCqR9pzPZndwY3/Y2m23QcPj23v+/Xju0rVX0DKVLd8+38NnOGx+KyXoyhGIVKO3yj
         m7mx+NqzoZa+JBpWnnYcTmHPsLHyolqJGI2qs=
Message-ID: <4C8ABF15.8000108@gmail.com>
Date: Sat, 11 Sep 2010 01:28:21 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
        perfmon2-devel@lists.sf.net, eranian@gmail.com, robert.richter@amd.com,
        acme@redhat.com
Subject: Re: [PATCH percpu#for-next] percpu: clear memory allocated with the
 km allocator
References: <4c88dca1.44e7d80a.577e.3592@mx.google.com> <1284040322.2589.174.camel@edumazet-laptop> <AANLkTimHwiXa62GhHA0hQ0AOcDaxgqRcV+O63G_qoZW8@mail.gmail.com> <1284106566.402.26.camel@laptop> <4C89EF37.5080803@kernel.org> <4C89F1CE.4050302@gmail.com> <1284108918.402.31.camel@laptop> <20100910093115.2f0859af.randy.dunlap@oracle.com> <20100910164525.GA11188@elte.hu>
In-Reply-To: <20100910164525.GA11188@elte.hu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 06:45 PM, Ingo Molnar wrote:
> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Fri, 10 Sep 2010 10:55:18 +0200 Peter Zijlstra wrote:
>>
>>> On Fri, 2010-09-10 at 10:52 +0200, Tejun Heo wrote:
>>>> Percpu allocator should clear memory before returning it but the km
>>>> allocator forgot to do it.  Fix it.
>>>>
>>>> Signed-off-by: Tejun Heo <tj@kernel.org>
>>>> Spotted-by: Peter Zijlstra <peterz@infradead.org>
>>>
>>> (fwiw, -tip uses Reported-by)
>>
>> fyi, Documentation/SubmittingPatches does also.
> 
> Yeah, and, FYI, there's observed strong correlation between the 
> maintenance policies of -tip and Documentation/SubmittingPatches.
> [i'd even venture so far to claim causation]

Oh, I already updated it to be Reported-by.  I use Spotted-by when to
distinguish the cases where the root cause is diagnosed by the
reporter as opposed to when the reporter just reported a bug but I
suppose it's just causing more confusion.  I'll just use Reproted-by
from now on.

Thank you.

-- 
tejun

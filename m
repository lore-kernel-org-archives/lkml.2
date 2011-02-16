Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab1BPETF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:19:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54912 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab1BPETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:19:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bMvrzuS6IFapc/GKPU+qs5C5U+IKygimVDhrMbqCLVxBJwv+/sCWzqrWVRt6OIdvqg
         ULcfkoUeJf58bU5JtVxGXmi0dog9MG3Ry4qnZTghXj/peVJFnzudjP2fQMS4zH9NGmvT
         /k3BuRw+og2EqHInAoRqD1Dyx2aKYz7UasKMo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
References: <4D484853.9020409@gmail.com>
	<20110202023610.3799.qmail@science.horizon.com>
	<AANLkTi=X8vCuVOCMBJiCOB-8GZRF4-5RVx59QchecLz4@mail.gmail.com>
	<AANLkTikLVMNQzmugH-ORc89_ZouX6zWvG-tHSf1QoVf3@mail.gmail.com>
Date: Wed, 16 Feb 2011 07:19:00 +0300
Message-ID: <AANLkTikx-7zJZaV2tgP=D=vZ12Brp9qrnyxLv_mVXQT3@mail.gmail.com>
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: George Spelvin <linux@horizon.com>, a.p.zijlstra@chello.nl,
        dzickus@redhat.com, eranian@google.com, linux-kernel@vger.kernel.org,
        ming.m.lin@intel.com, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/11, Dave Airlie <airlied@gmail.com> wrote:
> On Wed, Feb 2, 2011 at 2:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On 2/2/11, George Spelvin <linux@horizon.com> wrote:
>>>>  But if you have a will or would like to help debug the problem -- mind
>>>> to
>>>> try the patch below? Note the patch is ugly at moment and must *not* be
>>>> running on non-P4 system (and I only compile-tested it so no guarantees
>>>> at all, and I've CC'ed a couple of people as well)
>>>
>>> Promising...  After 32 minute of uptime, no NMI complaints so far.
>>>
>>> I'll let it run overnight and see what happens.
>>>
>>
>> Great, thanks. Though the patch didn't help for Don, ie there is still
>> an issue which needs to be resolved as well.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Ping on this problem, still seeing
>
> Uhhuh. NMI received for unknown reason 3c on CPU 0.
> Do you have a strange power saving mode enabled?
> Dazed and confused, but trying to continue
>
> on my Pentium-D system here with latest Linus head.
>
> its sometimes 3c, sometimes 3d, I'm going to bisect and push for
> reverts if nobody still has any clue about how to fix this.
>
> Dave.
>

We still trying to resolve it but without success yet. There is no
easy way to revert it. One of the option might be to disable perf on
p4 for a while. If this is acceptable -- i'll cook such patch and send
it to Ingo. Hm?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1ESIym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:54:42 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64048 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab1ESIyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LLk/XnptSLKSBxxqNzT5LQQCeFTYPRhVTEX30ic/PAeEw7jBrvHFJ7MraVYqmOWXNm
         cFaWZXJVmLE/+LyEtvx0XSf6deOLDcfFhfhRdkw+kxltH3koUkQ7WDMGMsOFi+rkvRTe
         AAnn3E1xcA6E5T7cekRsgXmfgkB5gBSiCdmIo=
MIME-Version: 1.0
In-Reply-To: <1305794708.2466.7194.camel@twins>
References: <20110428161149.GA15658@redhat.com>
	<20110502194416.2D61.A69D9226@jp.fujitsu.com>
	<20110502195657.2D68.A69D9226@jp.fujitsu.com>
	<1305129929.2914.247.camel@laptop>
	<4DCCC61F.80408@jp.fujitsu.com>
	<BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
	<1305306135.2466.173.camel@twins>
	<20110516133748.GB2058@zhy>
	<1305794708.2466.7194.camel@twins>
Date: Thu, 19 May 2011 16:54:40 +0800
Message-ID: <BANLkTi=GYr6XWyt50YaJ=WrDMFZ3aGAQkg@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 4:45 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-05-16 at 21:37 +0800, Yong Zhang wrote:
>>
>> But I'm afraid this patch still doesn't help.
>> If I understand your patch correctly, you just put the wake up to CPU_STARTING,
>> but it's still before CPU_ONLINE.\
>
> Well, that's the whole point really, CPU_ONLINE is terribly late. But
> did you perhaps mean to say its before we mark the cpu online?

I always try to express myself correctly(poor english :)

Precisely, it's before we mark the cpu active. sched_cpu_active()
is call when CPU_ONLINE.

Thanks,
Yong

>
>> Please check my mail to Paul's in this thread group.
>
> Not sure that made things any clearer.
>



-- 
Only stand for myself

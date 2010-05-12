Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab0ELON4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 10:13:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35431 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118Ab0ELONy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 10:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oWwYip9B83M41Dgr5aRrGBDIB+zIAb9eyZU5uBl/42ZMYWAKAgkSMiqPDp7tBd7Deo
         lVJO6Nkee5CQ+3GJZ2O3blVLM6LxcmLuFfUO1mfG1IuwIGYUCtp7o358yKMUyFb7aXnp
         JNZ/jbvROAmprLVmZ3FD/0celBAvBBC17i7WU=
MIME-Version: 1.0
In-Reply-To: <4BEAB6FC.8090105@intcomgrp.com>
References: <eJjRf-6YM-1@gated-at.bofh.it> <eJktY-7JG-7@gated-at.bofh.it>
	 <eJktY-7JG-5@gated-at.bofh.it> <4BEAB6FC.8090105@intcomgrp.com>
Date: Wed, 12 May 2010 16:13:53 +0200
Message-ID: <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Dhaval Giani <dhaval.giani@gmail.com>
To: James Kosin <jkosin@intcomgrp.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, menage@google.com,
       balbir@linux.vnet.ibm.com, lennart@poettering.net, jsafrane@redhat.com,
       tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please do *NOT* drop the cc list]

On Wed, May 12, 2010 at 4:11 PM, James Kosin <jkosin@intcomgrp.com> wrote:
> On 5/12/2010 9:50 AM, Dhaval Giani wrote:
>> On Wed, May 12, 2010 at 3:40 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> On Wed, 2010-05-12 at 15:05 +0200, Dhaval Giani wrote:
>>>> Where cpusets goes wrong is to have a *no* default values.
>>>
>>> It has a default, empty is still a valid value.
>>>
>>
>> Well, it is still not sane. And in the part you snipped, I did mention,
>>
>>>> do we enforce a policy to have sane defaults
>>>> for subsystems if they prevent attaching "regular" tasks by default.
>>
>> And to add to it, a sane default can be defined as one, where a task
>> can be attached to a cgroup on creation without changing any other
>> parameter.
>>
>> Dhaval
>
> By keeping the insane policy, we force everyone to properly setup to
> sane defaults.  By automatically inheriting the defaults, we would be
> introducing the possibility of a lazy programmer forgetting to setup the
> proper defaults for their application which may need different values
> than the inherited settings.  This would lead to ensuing chaos eventually.

Nope. Not really. What you are saying is that an application
programmer who wants to just use memory cgroups should also care about
cpusets and just about countless other cgroup subsystems that can
exist. A lazy programmer not setting up a sane value for what he cares
about will see abnormal execution of his application and be able to
fix it.

You are talking about moving the burden of setup to the people who
should be least concerned about it.

Dhaval

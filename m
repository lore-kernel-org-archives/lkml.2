Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab2BWVB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:01:58 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:54831 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2BWVB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:01:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.181.13.113 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<4F4661D6.7030809@gmail.com>
	<CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
	<alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
Date: Thu, 23 Feb 2012 16:01:56 -0500
Message-ID: <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: david@lang.hm
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 3:48 PM,  <david@lang.hm> wrote:
> On Thu, 23 Feb 2012, Jidong Xiao wrote:
>
>>>
>>> At least UIO drivers are already in Linux kernel, see drivers/uio/.
>>>
>>
>> Oh, so does it make sense to move existing device drivers into user
>> space? For example, move most of the stuff located under drivers/usb
>> into user-space?
>
>
> Why would you want to? What advantage are you looking to gain from all the
> effort?
>
Since device drivers are a significant source of bugs in OS. Moving
them to user space can reduce the impact of these bugs. Otherwise, why
UIO, or drivers/uio, is accepted by mainstream Linux kernel.

-Jidong

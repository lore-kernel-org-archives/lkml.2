Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2BWUsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:48:36 -0500
Received: from mail.lang.hm ([64.81.33.126]:37922 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab2BWUsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:48:35 -0500
Date: Thu, 23 Feb 2012 12:48:32 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Jidong Xiao <jidong.xiao@gmail.com>
cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
In-Reply-To: <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com> <4F4661D6.7030809@gmail.com> <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012, Jidong Xiao wrote:

>>
>> At least UIO drivers are already in Linux kernel, see drivers/uio/.
>>
>
> Oh, so does it make sense to move existing device drivers into user
> space? For example, move most of the stuff located under drivers/usb
> into user-space?

Why would you want to? What advantage are you looking to gain from all the 
effort?

David Lang

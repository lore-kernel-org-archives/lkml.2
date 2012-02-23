Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2BWQeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:34:10 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35512 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2BWQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:34:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.180.107.2 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4661D6.7030809@gmail.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<4F4661D6.7030809@gmail.com>
Date: Thu, 23 Feb 2012 11:34:08 -0500
Message-ID: <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 10:57 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On 02/23/2012 12:56 PM, Jidong Xiao wrote:
>>
>> Hi,
>
>
> Hi,
>
>
>> So is it mainly because the high overhead that prevents the user-space
>> device drivers ideas being accepted in Linux?
>>
>
> At least UIO drivers are already in Linux kernel, see drivers/uio/.
>

Oh, so does it make sense to move existing device drivers into user
space? For example, move most of the stuff located under drivers/usb
into user-space?

-Jidong

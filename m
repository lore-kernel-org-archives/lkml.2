Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab2BXPTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:19:39 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56372 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2BXPTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:19:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.216.134.39 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
Date: Fri, 24 Feb 2012 10:19:36 -0500
Message-ID: <CAG4AFWZD8LeFkidnESCMfYFVFbjekAMJ_OZCTc2NRKJsvN3Qjw@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 11:56 PM, Jidong Xiao <jidong.xiao@gmail.com> wrote:
> Hi,
>
> I am just curious. Since the concept user-space device drivers has
> been proposed for several years, and some related projects and
> research papers have demonstrated the feasibility of of moving device
> drivers into use space. In particular, this paper:
>
> Tolerating Malicious Device Drivers in Linux.
> http://pdos.csail.mit.edu/papers/sud:usenix10.pdf
>
> In this paper, existing device driver code need not to be changed,
> which should help the idea to be applied in practice.
>
> The advantage and disadvantage of move device drivers into use space
> of both obvious:
>
> Advantage: Since most of kernel bugs are caused by device drivers
> issues, moving device drivers into user space can reduce the impact of
> device driver bugs. From security perspective, the system can be more
> secure and robust if most device drivers are working in user space.
> Disadvantage: At least, existing techniques as well as the above paper
> showed a relatively high overhead.
>
> So is it mainly because the high overhead that prevents the user-space
> device drivers ideas being accepted in Linux?
>

Actually, my major concern is, since UIO has been accepted, then why
don't we move all the rest device drivers into user space as well. As
I understand, currently, some of device drivers are running on user
space, while the other (or say the majority of) device drivers are
running on kernel space, so why don't we maintain a consistent device
drivers infrastructure, say, either all in user space, or all in
kernel space. (Sure some critical device drivers still need to be kept
in kernel space.)

-Jidong

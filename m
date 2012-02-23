Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2BWP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 10:57:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50249 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab2BWP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 10:57:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xiyou.wangcong@gmail.com designates 10.68.189.39 as permitted sender) smtp.mail=xiyou.wangcong@gmail.com; dkim=pass header.i=xiyou.wangcong@gmail.com
Message-ID: <4F4661D6.7030809@gmail.com>
Date: Thu, 23 Feb 2012 23:57:10 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Jidong Xiao <jidong.xiao@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
In-Reply-To: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 12:56 PM, Jidong Xiao wrote:
> Hi,

Hi,

> So is it mainly because the high overhead that prevents the user-space
> device drivers ideas being accepted in Linux?
>

At least UIO drivers are already in Linux kernel, see drivers/uio/.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2BZAaA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 19:30:00 -0500
Received: from edge1.cs.stonybrook.edu ([130.245.9.210]:6708 "EHLO
	edge1.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2BZA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 19:29:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryao@cs.stonybrook.edu designates 10.42.150.200 as permitted sender) smtp.mail=ryao@cs.stonybrook.edu
MIME-Version: 1.0
In-Reply-To: <4F497782.3060902@redhat.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<4F4661D6.7030809@gmail.com>
	<CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
	<alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
	<CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
	<20120224162109.1bbf157b@redhat.com>
	<20120225150940.GA3719@localhost>
	<4F497782.3060902@redhat.com>
Date: Sat, 25 Feb 2012 19:29:56 -0500
Message-ID: <CABDyM6RNj=7_=rPBHs8YLayM9gPkCCYVo+XugnpOWDDgJeZFjw@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Jidong Xiao <jidong.xiao@gmail.com>, <david@lang.hm>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Originating-IP: [209.85.210.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 7:06 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> This is only partially true. The current debug tools available on the
> Kernel are not hard to deal with, and are not behind what's available
> on userspace.

Is there documentation available for these tools? I would find that useful.

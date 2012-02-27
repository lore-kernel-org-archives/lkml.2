Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2B0Lbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:31:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab2B0Lbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:31:52 -0500
Message-ID: <4F4B699C.2020607@redhat.com>
Date: Mon, 27 Feb 2012 08:31:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Richard Yao <ryao@cs.stonybrook.edu>
CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Jidong Xiao <jidong.xiao@gmail.com>, david@lang.hm,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Can we move device drivers into user-space?
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com> <4F4661D6.7030809@gmail.com> <CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com> <alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm> <CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com> <20120224162109.1bbf157b@redhat.com> <20120225150940.GA3719@localhost> <4F497782.3060902@redhat.com> <CABDyM6RNj=7_=rPBHs8YLayM9gPkCCYVo+XugnpOWDDgJeZFjw@mail.gmail.com>
In-Reply-To: <CABDyM6RNj=7_=rPBHs8YLayM9gPkCCYVo+XugnpOWDDgJeZFjw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-02-2012 22:29, Richard Yao escreveu:
> On Sat, Feb 25, 2012 at 7:06 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> This is only partially true. The current debug tools available on the
>> Kernel are not hard to deal with, and are not behind what's available
>> on userspace.
> 
> Is there documentation available for these tools? I would find that useful.

See Documentation/. You'll see there lots of interesting things that could
be used to debug a driver, including fixing performance issues on it: kdbg,
remote console, perf, dynamic printk's, etc.

Mauro.

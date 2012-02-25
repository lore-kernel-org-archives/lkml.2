Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2BYPb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 10:31:57 -0500
Received: from edge2.cs.stonybrook.edu ([130.245.9.211]:59575 "EHLO
	edge2.cs.stonybrook.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2BYPb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 10:31:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ryao@cs.stonybrook.edu designates 10.42.150.200 as permitted sender) smtp.mail=ryao@cs.stonybrook.edu
MIME-Version: 1.0
In-Reply-To: <20120224162109.1bbf157b@redhat.com>
References: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
	<4F4661D6.7030809@gmail.com>
	<CAG4AFWa3cs-V+wfL8o6PauTAOtvj8t1E_iSN5r0A8z=Aqzg0tg@mail.gmail.com>
	<alpine.DEB.2.02.1202231247550.1803@asgard.lang.hm>
	<CAG4AFWbfrTtq2OCrkrXfF-VV1+80oUE1Nfaxg5US3hNX3AiQ6A@mail.gmail.com>
	<20120224162109.1bbf157b@redhat.com>
Date: Sat, 25 Feb 2012 10:31:54 -0500
Message-ID: <CABDyM6RdnY0OHcWauS124nXVpPj_8pOLVd6gcaLbTgCHBoQang@mail.gmail.com>
Subject: Re: Can we move device drivers into user-space?
From: Richard Yao <ryao@cs.stonybrook.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Jidong Xiao <jidong.xiao@gmail.com>, <david@lang.hm>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Originating-IP: [209.85.210.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The impact of the bug won't also reduce, on most cases, as the userspace driver
> will very likely require root capabilities.

This is incorrect. root capabilities can be isolated via security
frameworks like SELinux. Ring 0 code cannot.

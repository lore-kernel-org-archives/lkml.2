Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2BWE43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 23:56:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41098 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2BWE42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 23:56:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jidong.xiao@gmail.com designates 10.180.107.2 as permitted sender) smtp.mail=jidong.xiao@gmail.com; dkim=pass header.i=jidong.xiao@gmail.com
MIME-Version: 1.0
Date: Wed, 22 Feb 2012 23:56:27 -0500
Message-ID: <CAG4AFWb0iG_t+Ps2isC_DF=f3WfVKyL+H-=ybKCtRP=ZmAAUUA@mail.gmail.com>
Subject: Can we move device drivers into user-space?
From: Jidong Xiao <jidong.xiao@gmail.com>
To: Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am just curious. Since the concept user-space device drivers has
been proposed for several years, and some related projects and
research papers have demonstrated the feasibility of of moving device
drivers into use space. In particular, this paper:

Tolerating Malicious Device Drivers in Linux.
http://pdos.csail.mit.edu/papers/sud:usenix10.pdf

In this paper, existing device driver code need not to be changed,
which should help the idea to be applied in practice.

The advantage and disadvantage of move device drivers into use space
of both obvious:

Advantage: Since most of kernel bugs are caused by device drivers
issues, moving device drivers into user space can reduce the impact of
device driver bugs. From security perspective, the system can be more
secure and robust if most device drivers are working in user space.
Disadvantage: At least, existing techniques as well as the above paper
showed a relatively high overhead.

So is it mainly because the high overhead that prevents the user-space
device drivers ideas being accepted in Linux?

Regards
-Jidong

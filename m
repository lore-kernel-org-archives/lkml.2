Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1BAGkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 01:40:24 -0500
Received: from lo.gmane.org ([80.91.229.12]:38488 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1BAGkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 01:40:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: what is spinlock depth
Date: Tue, 1 Feb 2011 06:40:06 +0000 (UTC)
Message-ID: <ii89s6$8dp$1@dough.gmane.org>
References: <AANLkTik4WQreo35jGLMQA16u+R-Ed036B3okrrx2nBGy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kernelnewbies@nl.linux.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 15:27:08 -0500, Sri Ram Vemulpali wrote:

> Hi all,
> 
> I am reading spinlock code and looking at struct raw_spinlock. I found
> struct lockdep_map as member.
...
> Can anyone help me explain, how this struct helps the spinlock. Why do
> we need lockdepth.

Here "lockdep" is short for Lock Dependence, not Lock Depth.

We do have lock depth things, e.g. ->lock_depth of struct task_struct,
which means the nested level of BKL. But spinlock can't be nested.


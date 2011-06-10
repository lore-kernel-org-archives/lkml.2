Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1FJAIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:08:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab1FJAIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:08:38 -0400
Date: Thu, 9 Jun 2011 17:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        efault@gmx.de, Arne Jansen <lists@die-jansens.de>
Subject: Re: [PATCH 1/3] printk: Release console_sem after logbuf_lock
Message-Id: <20110609170804.1b76e853.akpm@linux-foundation.org>
In-Reply-To: <alpine.LSU.2.00.1106091655560.2710@sister.anvils>
References: <20110609130647.937204592@chello.nl>
	<20110609131307.493181962@chello.nl>
	<20110609130617.f8aca966.akpm@linux-foundation.org>
	<20110609202707.GA28951@elte.hu>
	<1307652883.2497.1028.camel@laptop>
	<20110609140714.fc9ea187.akpm@linux-foundation.org>
	<alpine.LSU.2.00.1106091655560.2710@sister.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 16:57:29 -0700 (PDT)
Hugh Dickins <hughd@google.com> wrote:

> Does your mail below stir any useful memories?

Thanks.  I did have the email, but it didn't match any of my grep
patterns.

> Some notes:

Stupid thing doesn't explain the magical locking though :( I'm 99.9%
sure that putting an up() inside a spinlock_irq()ed region was
deliberate.

> - Being heartily sick of reverse-engineering interface information
>   from implementations, I have gratuitously added comments in several
>   random parts of the kernel.  Shoot me.

hah.

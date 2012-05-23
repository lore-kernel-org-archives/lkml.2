Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2EWXYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2EWXYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:24:45 -0400
Date: Thu, 24 May 2012 01:24:42 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: ethan zhao <ethan.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Huge memory takes too long time to initialize on 4TB memory ?
Message-ID: <20120523232441.GC4071@redhat.com>
References: <CABawtvN4Cwm3iFBB9hkDREHgtVYTni93TQ4SqezyLMtVAqhqVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvN4Cwm3iFBB9hkDREHgtVYTni93TQ4SqezyLMtVAqhqVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 23, 2012 at 10:36:01AM +0800, ethan zhao wrote:
> Hi, aarcange
> 
>    When I boot kernel 2.6.39-100.6.1.el6uek.x86_64(actually 3.0.26)on a 4TB
> machine, got following call trace,
> That shows huge memory take too long time to initialize ? any help ?, I
> compared the huge_memory.c code between 3.0.26 and the current 3.2.x, no
> change.
> 
> Pid: 1, comm: swapper Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1 Oracle
> Corporation  Sun Fire X4800 M2 /
> RIP: 0010:[<ffffffff814fb2d9>]  [<ffffffff814fb2d9>]
> _raw_spin_unlock_irqrestore+**0x19/0x30

Could you reproduce it with an upstream (or with RHEL) kernel? It may
be reproducible upstream, but it looks like some kind of memory
corruption or zone dangling pointer so it's hard to tell if it's
upstraem too or not, by just reading the oops.

Thanks,
Andrea

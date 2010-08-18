Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab0HRRYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 13:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0HRRYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 13:24:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <AANLkTik0q6rzcvC6WYLaRESB2hL=CVD9F9X4N3PZ=YGg@mail.gmail.com>
References: <AANLkTik0q6rzcvC6WYLaRESB2hL=CVD9F9X4N3PZ=YGg@mail.gmail.com> <20100817225256.4775.6641.stgit@warthog.procyon.org.uk> <20100818055045.GD5243@cr0.nay.redhat.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: dhowells@redhat.com,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        torvalds@osdl.org, akpm@linux-foundation.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] Make do_execve() take a const filename pointer
Date: Wed, 18 Aug 2010 18:23:50 +0100
Message-ID: <7277.1282152230@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck <tony.luck@gmail.com> wrote:

> Okay in principle to me too ... but you missed a couple of sys_execve()
> declarations. I'll fix up the one in arch/ia64/include/asm/unistd.h (it can
> just be deleted).

Thanks.

> There is also an unchanged declaration in asm-generic/syscalls.h which may
> need to be investigated.

I didn't expect one to occur in a generic header file.  There's an array of
weird and wonderful declarations of this syscall out there.

David

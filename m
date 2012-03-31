Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab2CaT2e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 15:28:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab2CaT2b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 15:28:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333086729-14263-1-git-send-email-gerg@uclinux.org>
References: <1333086729-14263-1-git-send-email-gerg@uclinux.org>
To: gerg@uclinux.org
Cc: dhowells@redhat.com, linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        geert@linux-m68k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k: include asm/cmpxchg.h in our m68k atomic.h
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 31 Mar 2012 20:28:19 +0100
Message-ID: <31523.1333222099@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<gerg@uclinux.org> wrote:

> From: Greg Ungerer <gerg@uclinux.org>
> 
> After commit 9ffc93f203c18a70623f21950f1dd473c9ec48cd ("Remove all
> 
>   CC      init/main.o
> In file included from include/linux/mm.h:15:0,
>                  from include/linux/ring_buffer.h:5,
>                  from include/linux/ftrace_event.h:4,
>                  from include/trace/syscall.h:6,
>                  from include/linux/syscalls.h:78,
>                  from init/main.c:16:
> include/linux/debug_locks.h: In function ‘__debug_locks_off’:
> include/linux/debug_locks.h:16:2: error: implicit declaration of function ‘xchg’
> 
> There is no indirect inclusions of the new asm/cmpxchg.h for m68k here.
> Looking at most other architectures they include asm/cmpxchg.h in their
> asm/atomic.h. M68k currently does not do this. Including this in atomic.h
> fixes all m68k build problems.
> 
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Acked-by: David Howells <dhowells@redhat.com>

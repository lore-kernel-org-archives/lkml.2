Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2DBFyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:54:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2DBFyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:54:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1333312727-11428-12-git-send-email-paul.gortmaker@windriver.com>
References: <1333312727-11428-12-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH 11/11] asm-generic: add linux/types.h to cmpxchg.h
Date: Mon, 02 Apr 2012 06:53:45 +0100
Message-ID: <30225.1333346025@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Builds of the openrisc or1ksim_defconfig show the following:
> 
>   In file included from arch/openrisc/include/generated/asm/cmpxchg.h:1:0,
>                    from include/asm-generic/atomic.h:18,
>                    from arch/openrisc/include/generated/asm/atomic.h:1,
>                    from include/linux/atomic.h:4,
>                    from include/linux/dcache.h:4,
>                    from fs/notify/fsnotify.c:19:
>   include/asm-generic/cmpxchg.h: In function '__xchg':
>   include/asm-generic/cmpxchg.h:34:20: error: expected ')' before 'u8'
>   include/asm-generic/cmpxchg.h:34:20: warning: type defaults to 'int' in type name
> 
> and many more lines of similar errors.  It seems specific to the or32
> because most other platforms have an arch specific component that would
> have already included types.h ahead of time, but the o32 does not.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jonas Bonn <jonas@southpole.se>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: David Howells <dhowells@redhat.com

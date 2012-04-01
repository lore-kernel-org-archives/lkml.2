Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2DAVfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 17:35:33 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63075 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2DAVfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 17:35:32 -0400
Date: Mon, 2 Apr 2012 00:35:25 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
Message-ID: <20120401213525.GD4408@p183.telecom.by>
References: <20120401125741.GA7484@p183.telecom.by>
 <201204011921.59596.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204011921.59596.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 07:21:59PM +0000, Arnd Bergmann wrote:
> On Sunday 01 April 2012, Alexey Dobriyan wrote:
> >  arch/x86/syscalls/syscall_32.tbl |    1 +
> >  arch/x86/syscalls/syscall_64.tbl |    1 +
> >  fs/Makefile                      |    1 +
> >  fs/nextfd.c                      |   27 +++++++++++++++++++++++++++
> >  include/linux/syscalls.h         |    1 +
> >  5 files changed, 31 insertions(+)
> 
> I don't have any comments on the syscall itself, but when you add one, please
> also make the change to include/asm-generic/unistd.h so it appears in the
> various architectures using the generic syscall table.

I will.
The amount of places to plug new syscall is suprising. :-(

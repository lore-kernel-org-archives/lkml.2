Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2IXUiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 16:38:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757874Ab2IXUiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 16:38:06 -0400
Subject: Re: [PATCH] syscalls: add __NR_kcmp syscall to generic unistd.h
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Mon, 24 Sep 2012 16:38:02 -0400
In-Reply-To: <201209242001.16373.arnd@arndb.de>
References: <1348516024-4992-1-git-send-email-msalter@redhat.com>
	 <201209242001.16373.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1348519084.20929.46.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 20:01 +0000, Arnd Bergmann wrote:
> On Monday 24 September 2012, Mark Salter wrote:
> > 
> > Commit d97b46a64 added a new syscall (__NR_kcmp) to support checkpoint
> > restore. It is currently x86-only, but that restriction will be removed
> > in a subsequent patch. Unfortunately, the kernel checksyscalls script
> > had a bug which suppressed any warning to other architectures that the
> > kcmp syscall was not implemented. A patch to checksyscalls is being
> > tested in linux-next and other architectures are seeing warnings about
> > kcmp being unimplemented.
> > 
> > This patch adds __NR_kcmp to <asm-generic/unistd.h> so that kcmp is
> > wired in for architectures using the generic syscall list.
> > 
> > Signed-off-by: Mark Salter <msalter@redhat.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> If you have other patches lined up, can you add this one as well?

Yes. I can push it from the c6x tree.



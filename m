Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030241Ab2GMFm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 01:42:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab2GMFmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 01:42:25 -0400
Date: Thu, 12 Jul 2012 22:45:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dedekind1@gmail.com
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Dushistov <dushistov@mail.ru>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] fs/ufs: stop using write_supers and s_dirt
Message-Id: <20120712224538.31cb1e18.akpm@linux-foundation.org>
In-Reply-To: <1342157684.23418.6.camel@brekeke>
References: <1342099688-14894-1-git-send-email-dedekind1@gmail.com>
	<20120712155808.807ec3f5.akpm@linux-foundation.org>
	<1342157684.23418.6.camel@brekeke>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012 08:34:44 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Thu, 2012-07-12 at 15:58 -0700, Andrew Morton wrote:
> > Just fix them up as you go - the code is already a mixture of "right"
> > and "wrong" (a consequence of a lot of it being "wrong") - we might as
> > well tip it further in the "right" direction. 
> 
> Yeah, but I'd say 80% of it has its own "wrong" coding style, so fixing
> it is a separate patch-set. Simply because when I partially fix it,
> there are almost always context lines which upset checkpatch.pl, so I
> would need to fix it all. I can easily clean it up a bit separately,
> just let me know if you want me to do this.

checkpatch does not report on context lines - only on added lines.

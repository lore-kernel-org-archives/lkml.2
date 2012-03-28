Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab2C1OJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 10:09:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51005 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab2C1OJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 10:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <1332943060-18374-1-git-send-email-hagen@jauu.net>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
Date: Wed, 28 Mar 2012 16:09:24 +0200
Message-ID: <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>, jbaron@redhat.com,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:57 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> High performance server sometimes create one listening socket (e.g. port
> 80), create a epoll file descriptor and add the socket. Afterwards
> create SC_NPROCESSORS_ONLN threads and wait for events. This often
> result in a thundering herd problem because all CPUs are scheduled.
>
> This patch add an additional flag to epoll_ctl(2) called EPOLLEXCLUSIVE.
> If a descriptor is added with this flag only one CPU is scheduled in.
>
> Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
> ---
> Dave rejected the patch and said not network specific. Because there
> is no epoll maintainer this time directly.

CC'ing maintainers for you...
Please use scripts/get_maintainer.pl.

-- 
Thanks,
//richard

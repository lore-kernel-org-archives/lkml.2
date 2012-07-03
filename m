Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab2GCLPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:15:32 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52569 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635Ab2GCLPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:15:30 -0400
MIME-Version: 1.0
X-Originating-IP: [62.165.251.74]
In-Reply-To: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
References: <1340646378-5169-1-git-send-email-miklos@szeredi.hu>
Date: Tue, 3 Jul 2012 13:15:29 +0200
Message-ID: <CAJfpegttMWUSxEqhdC8Bf9jfe7cw-mknubfS-rnV=z_e6i_sLQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] audit-tree fixes
From: Miklos Szeredi <miklos@szeredi.hu>
To: eparis@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

On Mon, Jun 25, 2012 at 7:46 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Short series to fix refcounting in audit-tree.
>
> Please apply.

What's the  status of this, please?

Is there a public git tree for audit?

Thanks,
Miklos


> ---
> Miklos Szeredi (3):
>       audit: don't free_chunk() after fsnotify_add_mark()
>       audit: fix refcounting in audit-tree
>       audit: clean up refcounting in audit-tree
>
> ---
>  kernel/audit_tree.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
>
>

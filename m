Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965594Ab0COSGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:06:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:45648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab0COSGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:06:34 -0400
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 14:06:33 EDT
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CpvhwRDXMAX/nGl4O5wOYuK1fMVAij9Jb/6apWhh4Z61IGdbvh8m/9VnBhb6i5jba
	v11YvlSlS2Pr02GGB5+YA==
MIME-Version: 1.0
In-Reply-To: <4B9DA778.7080305@cn.fujitsu.com>
References: <4B9DA6E4.4020501@cn.fujitsu.com> <4B9DA778.7080305@cn.fujitsu.com>
Date: Mon, 15 Mar 2010 10:53:01 -0700
Message-ID: <6599ad831003151053jd4c267ck1500725f228a3230@mail.gmail.com>
Subject: Re: [PATCH] cgroups: remove duplicate include
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 8:20 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> commit e6a1105b ("cgroups: subsystem module loading interface")
> and commit c50cc752 ("sched, cgroups: Fix module export")
> result in duplicate including of module.h
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

> ---
>
> Fix changelog...
>
> ---
>  kernel/cgroup.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index ef909a3..e2769e1 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -27,7 +27,6 @@
>  */
>
>  #include <linux/cgroup.h>
> -#include <linux/module.h>
>  #include <linux/ctype.h>
>  #include <linux/errno.h>
>  #include <linux/fs.h>
> --
> 1.6.3
>

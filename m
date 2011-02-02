Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BBVVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 16:21:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1BBVV3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 16:21:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=deFqgKvzzQIu9fWt1HskCJzOLc0f7HN3DvBWfB0fOSa0b0MLxtCAUxRlRvqj777Cr5
         J0tU16yOp1e/wS83s4mg==
MIME-Version: 1.0
In-Reply-To: <1296679656-31163-2-git-send-email-kirill@shutemov.name>
References: <1296679656-31163-1-git-send-email-kirill@shutemov.name> <1296679656-31163-2-git-send-email-kirill@shutemov.name>
From: Paul Menage <menage@google.com>
Date: Wed, 2 Feb 2011 13:21:03 -0800
Message-ID: <AANLkTimepM-TUXSvZh_15xNWf2P0TDEOatPTN7yT2uQe@mail.gmail.com>
Subject: Re: [PATCH, v3 1/2] cgroups: export cgroup_iter_{start,next,end}
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 12:47 PM, Kirill A. Shutsemov
<kirill@shutemov.name> wrote:
> From: Kirill A. Shutemov <kirill@shutemov.name>
>
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Acked-by: Paul Menage <menage@google.com>

> ---
>  kernel/cgroup.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b24d702..8234daa 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2443,6 +2443,7 @@ void cgroup_iter_start(struct cgroup *cgrp, struct cgroup_iter *it)
>        it->cg_link = &cgrp->css_sets;
>        cgroup_advance_iter(cgrp, it);
>  }
> +EXPORT_SYMBOL_GPL(cgroup_iter_start);
>
>  struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
>                                        struct cgroup_iter *it)
> @@ -2467,11 +2468,13 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
>        }
>        return res;
>  }
> +EXPORT_SYMBOL_GPL(cgroup_iter_next);
>
>  void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it)
>  {
>        read_unlock(&css_set_lock);
>  }
> +EXPORT_SYMBOL_GPL(cgroup_iter_end);
>
>  static inline int started_after_time(struct task_struct *t1,
>                                     struct timespec *time,
> --
> 1.7.3.5
>
>

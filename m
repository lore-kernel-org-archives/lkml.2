Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2KMNNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:13:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51157 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab2KMNNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:13:12 -0500
MIME-Version: 1.0
In-Reply-To: <20121113121329.94457adzis4fk5t5@vinovium.com>
References: <20121113121329.94457adzis4fk5t5@vinovium.com>
Date: Tue, 13 Nov 2012 14:13:11 +0100
Message-ID: <CAFLxGvznPRr=7Q0ePyggOjWN2V0oZULty9eXb1S3+YCfF3Y8_Q@mail.gmail.com>
Subject: Re: Sched - trivial spelling patch
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: David R <david@unsolicited.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 1:13 PM, David R <david@unsolicited.net> wrote:
> Spell "logarithmic" correctly in sched debug.
>
> --- kernel/sched/debug.c.orig   2012-11-13 11:52:59.000000000 +0000
> +++ kernel/sched/debug.c        2012-11-13 11:53:30.000000000 +0000
> @@ -318,7 +318,7 @@
>
>  static const char *sched_tunable_scaling_names[] = {
>         "none",
> -       "logaritmic",
> +       "logarithmic",
>         "linear"
>  };
>

Your patch is missing a Signed-off-by tag.
Please use checkpatch.pl to verify your patch.

On the other hand I'm not sure if this change is a good idea.
sched_tunable_scaling_names is exposed to user space,
changing a member may break existing applications.

-- 
Thanks,
//richard

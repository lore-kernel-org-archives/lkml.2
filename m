Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2LQTIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:08:52 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50996 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQTIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:08:50 -0500
MIME-Version: 1.0
In-Reply-To: <876244xpbj.fsf@xmission.com>
References: <87txroxpgq.fsf@xmission.com> <876244xpbj.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 11:08:29 -0800
Message-ID: <CALCETrWEoAh3H-eQABJz+G31P4iiQUeE+j-93diHHYpPLGv2Yw@mail.gmail.com>
Subject: Re: [PATCH 4/4] userns: Fix typo in description of the limitation of userns_install
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 2:05 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  kernel/user_namespace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index f5975cc..2b042c4 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -799,7 +799,7 @@ static int userns_install(struct nsproxy *nsproxy, void *ns)
>         if (user_ns == current_user_ns())
>                 return -EINVAL;
>
> -       /* Threaded many not enter a different user namespace */
> +       /* Threaded processes may not enter a different user namespace */
>         if (atomic_read(&current->mm->mm_users) > 1)
>                 return -EINVAL;
>
> --
> 1.7.5.4
>

Acked-by: Andy Lutomirski <luto@amacapital.net>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab2LNXbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:31:25 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58697 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab2LNXbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:31:23 -0500
Date: Fri, 14 Dec 2012 23:36:32 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/4] userns: Fix typo in description of the limitation
 of userns_install
Message-ID: <20121214233632.GB13659@mail.hallyn.com>
References: <87txroxpgq.fsf@xmission.com>
 <876244xpbj.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876244xpbj.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/user_namespace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index f5975cc..2b042c4 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -799,7 +799,7 @@ static int userns_install(struct nsproxy *nsproxy, void *ns)
>  	if (user_ns == current_user_ns())
>  		return -EINVAL;
>  
> -	/* Threaded many not enter a different user namespace */
> +	/* Threaded processes may not enter a different user namespace */
>  	if (atomic_read(&current->mm->mm_users) > 1)
>  		return -EINVAL;
>  
> -- 
> 1.7.5.4

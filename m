Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab2EPQqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab2EPQqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:46:01 -0400
Date: Wed, 16 May 2012 18:43:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: linux-next: manual merge of the akpm with the  tree
Message-ID: <20120516164323.GA15140@redhat.com>
References: <20120516193052.4af4ee85feb4a36b936b74df@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516193052.4af4ee85feb4a36b936b74df@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Stephen Rothwell wrote:
>
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@@ -1218,7 -1218,7 +1218,7 @@@ static int wait_task_zombie(struct wait
>   	unsigned long state;
>   	int retval, status, traced;
>   	pid_t pid = task_pid_vnr(p);
> - 	uid_t uid = from_kuid_munged(current_user_ns(), __task_cred(p)->uid);
>  -	uid_t uid = task_uid(p);
> ++	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
>   	struct siginfo __user *infop;

Thanks Stephen, the fix looks correct.

Oleg.

